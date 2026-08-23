# =============================================================================
#  predict.py
#  XGBoost Telecom Fault Classifier — Inference / Deployment Script
#
#  THREE USAGE MODES
#  ─────────────────
#  A) Single record (dict)
#       python predict.py
#
#  B) Batch prediction from CSV / Excel
#       python predict.py --input new_records.csv
#       python predict.py --input new_records.xlsx
#
#  C) Import as a module in your own code
#       from predict import FaultPredictor
#       fp = FaultPredictor("xgb_model_artifacts")
#       result = fp.predict_single({...})
#
#  REQUIRED ARTIFACTS (all in the same folder):
#       xgb_model.pkl
#       scaler.pkl
#       label_encoder.pkl
#       feature_columns.json
# =============================================================================

import os
import json
import joblib
import argparse
import warnings
warnings.filterwarnings("ignore")

import numpy as np
import pandas as pd


# ─────────────────────────────────────────────────────────────────────────────
# CONSTANTS  (must match what was used during training)
# ─────────────────────────────────────────────────────────────────────────────
FAULT_MAP = {
    "TX Failure"               : "TX failure",
    "Planned Activity"         : "Planned activity",
    "Faulty cable or connector": "Faulty connector/cable",
}

RAW_FEATURE_COLS = [
    "AVAILABILITY",
    "ERAB_Establishment_SUCCESS_RATE",
    "CALL_SET_UP_SUCCESS_RATE",
    "DROP_CALL_RATE",
    "AVERAGE_LATENCY",
    "CELL_TROUGHPUT",
    "PRB_UTILIZATION",
]

ALL_REGIONS = [
    "AHAFO", "ASHANTI", "BONO", "BONO EAST", "CENTRAL",
    "EASTERN", "GREATER ACCRA", "NORTH EAST", "NORTHERN",
    "OTI", "UPPER EAST", "UPPER WEST", "VOLTA",
    "WESTERN", "WESTERN NORTH",
]


# ─────────────────────────────────────────────────────────────────────────────
# PREDICTOR CLASS
# ─────────────────────────────────────────────────────────────────────────────
class FaultPredictor:
    """
    Load saved XGBoost artifacts and serve predictions.

    Parameters
    ----------
    artifact_dir : str
        Path to the folder containing all .pkl and .json artifacts.
    """

    def __init__(self, artifact_dir: str = "xgb_model_artifacts"):
        self.artifact_dir = artifact_dir
        self._load_artifacts()

    # ── LOAD ─────────────────────────────────────────────────────────────────
    def _load_artifacts(self):
        ad = self.artifact_dir
        self.model         = joblib.load(f"{ad}/xgb_model.pkl")
        self.scaler        = joblib.load(f"{ad}/scaler.pkl")
        self.label_encoder = joblib.load(f"{ad}/label_encoder.pkl")

        with open(f"{ad}/feature_columns.json") as fh:
            self.feature_columns = json.load(fh)

        self.classes = list(self.label_encoder.classes_)
        print(f"[FaultPredictor] Loaded artifacts from '{ad}'")
        print(f"  Model classes : {self.classes}")
        print(f"  Feature count : {len(self.feature_columns)}")

    # ── FEATURE PIPELINE ─────────────────────────────────────────────────────
    def _build_feature_row(self, record: dict) -> pd.DataFrame:
        """
        Convert a raw input dict into the feature vector expected by the model.

        Parameters
        ----------
        record : dict
            Keys must include:
              AVAILABILITY, ERAB_Establishment_SUCCESS_RATE,
              CALL_SET_UP_SUCCESS_RATE, DROP_CALL_RATE,
              AVERAGE_LATENCY, CELL_TROUGHPUT, PRB_UTILIZATION,
              REGION  (one of ALL_REGIONS)
        """
        row = pd.DataFrame([record])

        # One-hot encode REGION — add a column for every known region
        for region in ALL_REGIONS:
            col = f"REGION_{region}"
            row[col] = 1 if record.get("REGION", "") == region else 0

        # Drop the original REGION text column if present
        row.drop(columns=["REGION"], errors="ignore", inplace=True)

        # Derived features
        cssr = row["CALL_SET_UP_SUCCESS_RATE"].values[0]
        dcr  = row["DROP_CALL_RATE"].values[0]
        tp   = row["CELL_TROUGHPUT"].values[0]
        prb  = row["PRB_UTILIZATION"].values[0]
        avl  = row["AVAILABILITY"].values[0]

        row["DCR_CSSR_ratio"]    = dcr  / (cssr + 1e-9)
        row["TP_PRB_efficiency"] = tp   / (prb  + 1e-9)
        row["AVAIL_x_CSSR"]     = avl  *  cssr

        # Align to the exact training column order (add missing cols as 0)
        for col in self.feature_columns:
            if col not in row.columns:
                row[col] = 0

        return row[self.feature_columns]

    # ── SINGLE PREDICTION ────────────────────────────────────────────────────
    def predict_single(self, record: dict) -> dict:
        """
        Predict fault type for one base station record.

        Parameters
        ----------
        record : dict
            Raw KPI values + REGION string.

        Returns
        -------
        dict with keys:
            predicted_fault   — string label
            confidence        — probability of predicted class (0–1)
            all_probabilities — {class: probability} for all classes
        """
        X = self._build_feature_row(record)
        X_scaled = self.scaler.transform(X)

        probs     = self.model.predict_proba(X_scaled)[0]
        pred_idx  = int(np.argmax(probs))
        pred_label = self.label_encoder.inverse_transform([pred_idx])[0]

        return {
            "predicted_fault"  : pred_label,
            "confidence"       : round(float(probs[pred_idx]), 4),
            "all_probabilities": {
                cls: round(float(p), 4)
                for cls, p in zip(self.classes, probs)
            },
        }

    # ── BATCH PREDICTION ─────────────────────────────────────────────────────
    def predict_batch(self, input_path: str, output_path: str = None) -> pd.DataFrame:
        """
        Predict fault types for a CSV or Excel file.

        Parameters
        ----------
        input_path  : str  — path to .csv or .xlsx file
        output_path : str  — optional path to save results (.csv)

        Returns
        -------
        pandas DataFrame with original columns + PREDICTED_FAULT + CONFIDENCE
        """
        if input_path.endswith(".xlsx"):
            df = pd.read_excel(input_path)
        else:
            df = pd.read_csv(input_path)

        # Standardise labels if FAULT_TYPE column is present
        if "FAULT_TYPE" in df.columns:
            df["FAULT_TYPE"] = df["FAULT_TYPE"].replace(FAULT_MAP)

        rows = []
        for _, row in df.iterrows():
            record = row.to_dict()
            try:
                result = self.predict_single(record)
                rows.append({
                    "PREDICTED_FAULT": result["predicted_fault"],
                    "CONFIDENCE"     : result["confidence"],
                    **{f"PROB_{cls}": result["all_probabilities"][cls]
                       for cls in self.classes},
                })
            except Exception as exc:
                rows.append({"PREDICTED_FAULT": f"ERROR: {exc}", "CONFIDENCE": None})

        results_df = pd.concat([df.reset_index(drop=True),
                                pd.DataFrame(rows)], axis=1)

        if output_path:
            results_df.to_csv(output_path, index=False)
            print(f"[FaultPredictor] Batch results saved → {output_path}")

        return results_df

    # ── INSPECT MODEL ────────────────────────────────────────────────────────
    def feature_importance(self, top_n: int = 15) -> pd.DataFrame:
        """Return a DataFrame of the top N features by XGBoost gain importance."""
        importance = self.model.get_booster().get_score(importance_type="gain")
        df_imp = (
            pd.DataFrame(importance.items(), columns=["feature", "gain"])
            .sort_values("gain", ascending=False)
            .head(top_n)
            .reset_index(drop=True)
        )
        return df_imp


# ─────────────────────────────────────────────────────────────────────────────
# CLI  — run as script
# ─────────────────────────────────────────────────────────────────────────────
def main():
    parser = argparse.ArgumentParser(
        description="XGBoost Telecom Fault Classifier — Inference"
    )
    parser.add_argument(
        "--artifacts", default="xgb_model_artifacts",
        help="Path to folder containing model artifacts (default: xgb_model_artifacts)"
    )
    parser.add_argument(
        "--input", default=None,
        help="Path to input CSV or Excel file for batch prediction"
    )
    parser.add_argument(
        "--output", default="predictions.csv",
        help="Path to save batch prediction CSV (default: predictions.csv)"
    )
    args = parser.parse_args()

    # ── Load predictor ───────────────────────────────────────────────────────
    predictor = FaultPredictor(args.artifacts)

    # ── BATCH MODE ───────────────────────────────────────────────────────────
    if args.input:
        print(f"\n[Batch mode] Input  : {args.input}")
        print(f"             Output : {args.output}")
        results = predictor.predict_batch(args.input, args.output)
        print(f"\nFirst 5 predictions:")
        print(results[["PREDICTED_FAULT", "CONFIDENCE"]].head().to_string(index=False))

    # ── SINGLE DEMO MODE ─────────────────────────────────────────────────────
    else:
        print("\n[Single record demo — edit these values as needed]")
        demo_records = [
            {
                # Example 1: TX failure signature (high latency, low throughput)
                "AVAILABILITY"                   : 90.55,
                "ERAB_Establishment_SUCCESS_RATE" : 8202,
                "CALL_SET_UP_SUCCESS_RATE"        : 99.70,
                "DROP_CALL_RATE"                  : 0.01,
                "AVERAGE_LATENCY"                 : 578104519,
                "CELL_TROUGHPUT"                  : 251985664,
                "PRB_UTILIZATION"                 : 54.16,
                "REGION"                          : "ASHANTI",
            },
            {
                # Example 2: Cell failure signature (availability = 0)
                "AVAILABILITY"                   : 0.0,
                "ERAB_Establishment_SUCCESS_RATE" : 295,
                "CALL_SET_UP_SUCCESS_RATE"        : 87.89,
                "DROP_CALL_RATE"                  : 62.73,
                "AVERAGE_LATENCY"                 : 4012395,
                "CELL_TROUGHPUT"                  : 91131853,
                "PRB_UTILIZATION"                 : 26.17,
                "REGION"                          : "GREATER ACCRA",
            },
            {
                # Example 3: Planned activity (100% availability, low drop)
                "AVAILABILITY"                   : 100.0,
                "ERAB_Establishment_SUCCESS_RATE" : 4200,
                "CALL_SET_UP_SUCCESS_RATE"        : 99.93,
                "DROP_CALL_RATE"                  : 2.75,
                "AVERAGE_LATENCY"                 : 68248431,
                "CELL_TROUGHPUT"                  : 405112457,
                "PRB_UTILIZATION"                 : 80.30,
                "REGION"                          : "GREATER ACCRA",
            },
        ]

        for i, record in enumerate(demo_records, 1):
            result = predictor.predict_single(record)
            print(f"\n  ── Record {i} ──")
            print(f"  Region              : {record['REGION']}")
            print(f"  Availability        : {record['AVAILABILITY']}")
            print(f"  Drop Call Rate      : {record['DROP_CALL_RATE']}")
            print(f"  Predicted Fault     : {result['predicted_fault']}")
            print(f"  Confidence          : {result['confidence']:.1%}")
            print("  All probabilities   :")
            for cls, prob in sorted(result["all_probabilities"].items(),
                                    key=lambda x: -x[1]):
                bar = "█" * int(prob * 30)
                print(f"    {cls:<35} {prob:.4f}  {bar}")

    # ── FEATURE IMPORTANCE ───────────────────────────────────────────────────
    print("\n[Feature Importance — Top 10 by Gain]")
    print(predictor.feature_importance(top_n=10).to_string(index=False))


if __name__ == "__main__":
    main()
