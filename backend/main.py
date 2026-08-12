from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import os
from typing import List, Optional

# Local import from the same directory
from predict import FaultPredictor

app = FastAPI(title="Telecom Predictive Maintenance API")

# Initialize the predictor using the current directory for artifacts
current_dir = os.path.dirname(os.path.abspath(__file__))
predictor = FaultPredictor(current_dir)

class KPIInput(BaseModel):
    AVAILABILITY: float
    ERAB_Establishment_SUCCESS_RATE: float
    CALL_SET_UP_SUCCESS_RATE: float
    DROP_CALL_RATE: float
    AVERAGE_LATENCY: float
    CELL_TROUGHPUT: float
    PRB_UTILIZATION: float
    REGION: str

class PredictionResponse(BaseModel):
    predicted_fault: str
    confidence: float
    all_probabilities: dict

@app.get("/")
def read_root():
    return {
        "status": "online",
        "message": "Telecom AI ML API is running",
        "model_classes": predictor.classes
    }

@app.post("/predict", response_model=PredictionResponse)
def predict(data: KPIInput):
    try:
        record = data.dict()
        result = predictor.predict_single(record)
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    # Port is often dynamic on hosting providers, but 8000 is default
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)
