from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from app import database, auth, wallet
from sqlalchemy.orm import Session
from app.database import get_db

app = FastAPI(title="Mini Wallet API")

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Create DB tables if not exist
@app.on_event("startup")
def startup():
    database.Base.metadata.create_all(bind=database.engine)

# Routes
app.include_router(auth.router, tags=["Auth"])
app.include_router(wallet.router, tags=["Wallet"])
