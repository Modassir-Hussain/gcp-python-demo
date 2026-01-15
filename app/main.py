from fastapi import FastAPI
from app.api.health import router as health_router
import logging
logging.basicConfig(level=logging.INFO)



app = FastAPI(
    title="FastAPI on GCP Cloud Run",
    version="1.0.0"
)

app.include_router(health_router)

@app.get("/")
def root():
    logging.info("FastAPI service started")
    return {"message": "FastAPI running on GCP Cloud Run 🚀"}
    