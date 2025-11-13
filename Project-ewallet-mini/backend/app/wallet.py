from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from jose import JWTError, jwt
from fastapi.security import OAuth2PasswordBearer

from . import schemas, models, database
from dotenv import load_dotenv
import os

load_dotenv()

router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = "HS256"


# ========== Dependency: ตรวจสอบ JWT token ==========

def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(database.get_db)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise HTTPException(status_code=401, detail="Invalid token")
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")

    user = db.query(models.User).filter(models.User.username == username).first()
    if user is None:
        raise HTTPException(status_code=401, detail="User not found")
    return user


# ========== GET /wallet ==========

@router.get("/wallet", response_model=schemas.WalletResponse)
def get_wallet(current_user: models.User = Depends(get_current_user)):
    return current_user.wallet


# ========== POST /wallet/deposit ==========

@router.post("/wallet/deposit", response_model=schemas.WalletResponse)
def deposit(
    data: schemas.WalletAction,
    current_user: models.User = Depends(get_current_user),
    db: Session = Depends(database.get_db)
):
    current_user.wallet.balance += data.amount
    db.commit()
    db.refresh(current_user.wallet)
    return current_user.wallet


# ========== POST /wallet/withdraw ==========

@router.post("/wallet/withdraw", response_model=schemas.WalletResponse)
def withdraw(
    data: schemas.WalletAction,
    current_user: models.User = Depends(get_current_user),
    db: Session = Depends(database.get_db)
):
    if current_user.wallet.balance < data.amount:
        raise HTTPException(status_code=400, detail="Insufficient balance")

    current_user.wallet.balance -= data.amount
    db.commit()
    db.refresh(current_user.wallet)
    return current_user.wallet
