from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import os
from typing import List, Optional
import httpx
from dotenv import load_dotenv

# Load environment variables
# 1. Try to load from assets folder (Local Development)
env_path = os.path.join(os.path.dirname(__file__), '..', 'assets', 'tel_config.txt')
if os.path.exists(env_path):
    load_dotenv(dotenv_path=env_path)
# 2. Otherwise, check if a .env exists in current folder
elif os.path.exists(".env"):
    load_dotenv()
# 3. If neither exist, FastAPI will just use system environment variables (Render/Production)

# Local import from the same directory
from predict import FaultPredictor

app = FastAPI(title="Telecom Predictive Maintenance API")

# Add CORS middleware to allow requests from Flutter Web (localhost) and other origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,  # credentials cannot be used with allow_origins=["*"]
    allow_methods=["*"],
    allow_headers=["*"],
)

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
    DCR_CSSR_ratio: Optional[float] = None
    TP_PRB_efficiency: Optional[float] = None
    AVAIL_x_CSSR: Optional[float] = None

class PredictionResponse(BaseModel):
    predicted_fault: str
    confidence: float
    all_probabilities: dict

class SMSRequest(BaseModel):
    phoneNumber: str
    message: str

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

@app.post("/send-sms")
async def send_sms(data: SMSRequest):
    try:
        api_key = os.environ.get('ARKESEL_SMS_API_KEY')
        sender_id = os.environ.get('ARKESEL_SMS_SENDER_ID', 'TelecomMaint')
        # Use v2 API for more reliability
        base_url = "https://sms.arkesel.com/api/v2/sms/send"

        if not api_key:
            raise HTTPException(status_code=500, detail="SMS API Key not configured on server")

        async with httpx.AsyncClient() as client:
            payload = {
                'sender': sender_id,
                'message': data.message,
                'recipients': [data.phoneNumber],
            }
            headers = {
                'api-key': api_key,
                'Accept': 'application/json'
            }
            response = await client.post(base_url, json=payload, headers=headers)

            # Arkesel v2 returns 201 for success
            return {
                "success": response.status_code in [200, 201],
                "status_code": response.status_code,
                "data": response.json() if response.status_code in [200, 201] else response.text
            }
    except Exception as e:
        print(f"Error in send_sms proxy: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/sms-balance")
async def get_sms_balance():
    try:
        api_key = os.environ.get('ARKESEL_SMS_API_KEY')
        base_url = "https://sms.arkesel.com/api/v2/clients/balance-details"

        if not api_key:
            raise HTTPException(status_code=500, detail="SMS API Key not configured on server")

        async with httpx.AsyncClient() as client:
            headers = {
                'api-key': api_key,
                'Accept': 'application/json'
            }
            response = await client.get(base_url, headers=headers)

            if response.status_code == 200:
                return response.json()
            else:
                raise HTTPException(status_code=response.status_code, detail=response.text)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    # Port is often dynamic on hosting providers, but 8000 is default
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)
