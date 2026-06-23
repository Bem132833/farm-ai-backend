from fastapi import FastAPI

from app.db.database import Base, engine
from app.models.user import User


app =FastAPI(
    title="AI Farm Decision System",
    description="Backend API for crop recommendation and farm decision support",
    version="1.0.0",
)
# Create tables (TEMPORARY for now)
Base.metadata.create_all(bind=engine)

@app.get("/")
def home():
    return {
        "message": "AI Farm Decision System is running successfully!"
    }
@app.get("/health")
def health_check():
    return { "status": "ok",
            "system": "farm-ai-backend",
    } 
