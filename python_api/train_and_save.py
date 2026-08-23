# =============================================================================
#  train_and_save.py
#  XGBoost Telecom Fault Classifier — Train, Evaluate & Save for Deployment
#
#  USAGE:
#      python train_and_save.py
#
#  OUTPUT FILES (all saved to ./xgb_model_artifacts/):
#      xgb_model.pkl          — trained XGBoost model
#      scaler.pkl             — fitted MinMaxScaler
#      label_encoder.pkl      — fitted LabelEncoder
#      feature_columns.json   — ordered list of feature names
#      model_metadata.json    — training config, CV metrics, class info
# =============================================================================

import warnings
warnings.filterwarnings("ignore")

import os
import json
import joblib
import numpy as np
import pandas as pd
from datetime import datetime

from sklearn.preprocessing    import LabelEncoder, MinMaxScaler
from sklearn.model_selection  import StratifiedKFold
from sklearn.metrics          import (
    accuracy_score, precision_score, recall_score,
    f1_score, roc_auc_score, classification_report
)
from imblearn.over_sampling   import SMOTE
import xgboost as xgb


# ─────────────────────────────────────────────────────────────────────────────
# CONFIG  — edit these paths/settings if needed
# ─────────────────────────────────────────────────────────────────────────────
DATA_FILE    = "MY_DATA_24_DEC.xlsx"
OUTPUT_DIR   = "xgb_model_artifacts"
N_FOLDS      = 5
RANDOM_STATE = 42

XGB_PARAMS = dict(
    n_estimators     = 300,
    max_depth        = 4,
    learning_rate    = 0.05,
    subsample        = 0.8,
    colsample_bytree = 0.8,
    reg_alpha        = 0.1,
    reg_lambda       = 1.0,
    objective        = "multi:softprob",
    eval_metric      = "mlogloss",
    use_label_encoder= False,
    random_state     = RANDOM_STATE,
    n_jobs           = -1,
)

# ─────────────────────────────────────────────────────────────────────────────
# STEP 1 — LOAD DATA
# ─────────────────────────────────────────────────────────────────────────────
print("=" * 65)
print("  XGBoost Fault Classifier — Training Pipeline")
print("=" * 65)
print(f"\n[1] Loading {DATA_FILE} ...")

df = pd.read_excel(DATA_FILE)
print(f"    Raw shape: {df.shape}")

# ─────────────────────────────────────────────────────────────────────────────
# STEP 2 — CLEAN & STANDARDISE LABELS
# ─────────────────────────────────────────────────────────────────────────────
print("\n[2] Cleaning data ...")

FAULT_MAP = {
    "TX Failure"               : "TX failure",
    "Planned Activity"         : "Planned activity",
    "Faulty cable or connector": "Faulty connector/cable",
}
df["FAULT_TYPE"] = df["FAULT_TYPE"].replace(FAULT_MAP)
df.dropna(inplace=True)

print("    Fault type distribution:")
for fault, count in df["FAULT_TYPE"].value_counts().items():
    print(f"      {fault:<35} {count}")

# ─────────────────────────────────────────────────────────────────────────────
# STEP 3 — FEATURE ENGINEERING
# ─────────────────────────────────────────────────────────────────────────────
print("\n[3] Feature engineering ...")

# One-hot encode REGION
df_enc = pd.get_dummies(df, columns=["REGION"], drop_first=False)

# Derived features
df_enc["DCR_CSSR_ratio"]    = df_enc["DROP_CALL_RATE"]  / (df_enc["CALL_SET_UP_SUCCESS_RATE"] + 1e-9)
df_enc["TP_PRB_efficiency"] = df_enc["CELL_TROUGHPUT"]  / (df_enc["PRB_UTILIZATION"] + 1e-9)
df_enc["AVAIL_x_CSSR"]     = df_enc["AVAILABILITY"]    *  df_enc["CALL_SET_UP_SUCCESS_RATE"]

FEATURE_COLS = [c for c in df_enc.columns if c not in ["4G_eNode_B", "FAULT_TYPE"]]
X_raw = df_enc[FEATURE_COLS].values
y_raw = df_enc["FAULT_TYPE"].values

# Encode target
le = LabelEncoder()
y  = le.fit_transform(y_raw)
CLASS_NAMES = list(le.classes_)
N_CLASSES   = len(CLASS_NAMES)

print(f"    Total features : {len(FEATURE_COLS)}")
print(f"    Total samples  : {X_raw.shape[0]}")
print(f"    Classes ({N_CLASSES}) : {CLASS_NAMES}")

# ─────────────────────────────────────────────────────────────────────────────
# STEP 4 — 5-FOLD STRATIFIED CROSS-VALIDATION  (with SMOTE per fold)
# ─────────────────────────────────────────────────────────────────────────────
print(f"\n[4] {N_FOLDS}-Fold Stratified Cross-Validation + SMOTE ...")

SKF          = StratifiedKFold(n_splits=N_FOLDS, shuffle=True, random_state=RANDOM_STATE)
fold_metrics = []
all_preds, all_true, all_probs = [], [], []

for fold, (tr_idx, va_idx) in enumerate(SKF.split(X_raw, y), 1):

    # Split
    X_tr, X_va = X_raw[tr_idx], X_raw[va_idx]
    y_tr, y_va = y[tr_idx],     y[va_idx]

    # Scale inside fold (no leakage)
    sc_fold = MinMaxScaler()
    X_tr    = sc_fold.fit_transform(X_tr)
    X_va    = sc_fold.transform(X_va)

    # SMOTE on training fold only
    k_nn = min(5, min(np.bincount(y_tr)) - 1)
    X_res, y_res = SMOTE(random_state=RANDOM_STATE, k_neighbors=k_nn).fit_resample(X_tr, y_tr)

    # Train
    clf = xgb.XGBClassifier(num_class=N_CLASSES, **XGB_PARAMS)
    clf.fit(X_res, y_res)

    # Evaluate
    preds = clf.predict(X_va)
    probs = clf.predict_proba(X_va)

    all_preds.extend(preds)
    all_true.extend(y_va)
    all_probs.extend(probs)

    y_bin = np.eye(N_CLASSES)[y_va]
    auc   = roc_auc_score(y_bin, probs, average="macro", multi_class="ovr")

    m = {
        "fold"     : fold,
        "accuracy" : round(float(accuracy_score(y_va, preds)),                                        4),
        "precision": round(float(precision_score(y_va, preds, average="macro", zero_division=0)),     4),
        "recall"   : round(float(recall_score(y_va, preds,    average="macro", zero_division=0)),     4),
        "f1_macro" : round(float(f1_score(y_va, preds,        average="macro", zero_division=0)),     4),
        "auc_roc"  : round(float(auc),                                                                4),
    }
    fold_metrics.append(m)
    print(f"    Fold {fold}  Acc:{m['accuracy']:.4f}  Prec:{m['precision']:.4f}  "
          f"Rec:{m['recall']:.4f}  F1:{m['f1_macro']:.4f}  AUC:{m['auc_roc']:.4f}")

# Aggregate
METRIC_KEYS = ["accuracy", "precision", "recall", "f1_macro", "auc_roc"]
mean_m = {k: round(float(np.mean([f[k] for f in fold_metrics])), 4) for k in METRIC_KEYS}
std_m  = {k: round(float(np.std( [f[k] for f in fold_metrics])), 4) for k in METRIC_KEYS}

print("\n    ── Cross-Validation Summary ──")
for k in METRIC_KEYS:
    print(f"    {k:<12} Mean: {mean_m[k]:.4f}  ±  {std_m[k]:.4f}")

print("\n    Classification Report (pooled folds):")
print(classification_report(
    np.array(all_true), np.array(all_preds),
    target_names=CLASS_NAMES, zero_division=0
))

# ─────────────────────────────────────────────────────────────────────────────
# STEP 5 — FINAL RETRAIN ON FULL DATASET
# ─────────────────────────────────────────────────────────────────────────────
print("[5] Retraining on full dataset for deployment ...")

scaler_final  = MinMaxScaler()
X_full_scaled = scaler_final.fit_transform(X_raw)

k_nn_full = min(5, min(np.bincount(y)) - 1)
X_res_full, y_res_full = SMOTE(
    random_state=RANDOM_STATE, k_neighbors=k_nn_full
).fit_resample(X_full_scaled, y)

print(f"    Original samples : {X_raw.shape[0]}")
print(f"    After SMOTE      : {X_res_full.shape[0]}")

xgb_final = xgb.XGBClassifier(num_class=N_CLASSES, **XGB_PARAMS)
xgb_final.fit(X_res_full, y_res_full)
print("    Training complete.")

# ─────────────────────────────────────────────────────────────────────────────
# STEP 6 — SAVE ALL ARTIFACTS
# ─────────────────────────────────────────────────────────────────────────────
print(f"\n[6] Saving artifacts to ./{OUTPUT_DIR}/ ...")
os.makedirs(OUTPUT_DIR, exist_ok=True)

# Model
joblib.dump(xgb_final,   f"{OUTPUT_DIR}/xgb_model.pkl")

# Preprocessors
joblib.dump(scaler_final, f"{OUTPUT_DIR}/scaler.pkl")
joblib.dump(le,           f"{OUTPUT_DIR}/label_encoder.pkl")

# Feature list  (CRITICAL — predict.py must use identical columns & order)
with open(f"{OUTPUT_DIR}/feature_columns.json", "w") as fh:
    json.dump(FEATURE_COLS, fh, indent=2)

# Metadata
metadata = {
    "model_name"         : "XGBoost Telecom Fault Classifier",
    "version"            : "1.0.0",
    "trained_on"         : datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
    "dataset"            : DATA_FILE,
    "n_samples_original" : int(X_raw.shape[0]),
    "n_samples_after_smote": int(X_res_full.shape[0]),
    "n_features"         : len(FEATURE_COLS),
    "classes"            : CLASS_NAMES,
    "n_classes"          : N_CLASSES,
    "hyperparameters"    : {k: v for k, v in XGB_PARAMS.items()
                            if k not in ["use_label_encoder", "random_state", "n_jobs"]},
    "preprocessing" : {
        "scaling"          : "MinMaxScaler — fit on full training data",
        "oversampling"     : f"SMOTE  k_neighbors={k_nn_full}",
        "label_map_applied": FAULT_MAP,
        "derived_features" : ["DCR_CSSR_ratio", "TP_PRB_efficiency", "AVAIL_x_CSSR"],
        "region_encoding"  : "One-hot encoding via pd.get_dummies",
    },
    "cv_results" : {
        "strategy" : f"{N_FOLDS}-Fold Stratified CV + SMOTE (applied inside each fold)",
        "per_fold" : fold_metrics,
        "mean"     : mean_m,
        "std"      : std_m,
    },
    "deployment_artifacts": {
        "model"          : "xgb_model.pkl",
        "scaler"         : "scaler.pkl",
        "label_encoder"  : "label_encoder.pkl",
        "feature_columns": "feature_columns.json",
        "metadata"       : "model_metadata.json",
        "inference"      : "predict.py",
    },
}

with open(f"{OUTPUT_DIR}/model_metadata.json", "w") as fh:
    json.dump(metadata, fh, indent=2)

# Summary
print("\n    Saved files:")
for fname in sorted(os.listdir(OUTPUT_DIR)):
    size = os.path.getsize(f"{OUTPUT_DIR}/{fname}")
    print(f"      {fname:<35}  {size:>10,} bytes")

print("\n" + "=" * 65)
print("  TRAINING COMPLETE")
print(f"  Best mean F1  : {mean_m['f1_macro']:.4f} ± {std_m['f1_macro']:.4f}")
print(f"  Best mean AUC : {mean_m['auc_roc']:.4f} ± {std_m['auc_roc']:.4f}")
print(f"  Artifacts in  : ./{OUTPUT_DIR}/")
print("=" * 65)
