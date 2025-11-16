from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from jose import JWTError, jwt
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from . import schemas, models, database
from dotenv import load_dotenv
import os

# โหลด ENV
load_dotenv()

router = APIRouter()

SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = "HS256"

# ใช้ HTTPBearer (Swagger จะส่ง Bearer token มาให้ถูกต้อง)
security = HTTPBearer()


# ====================== JWT VALIDATION ======================

def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(database.get_db)
):

    token = credentials.credentials  # ดึง token จริงจาก Authorization header

    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")

        if username is None:
            raise HTTPException(status_code=401, detail="Invalid token")

    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")

    # หา user จาก database
    user = db.query(models.User).filter(models.User.username == username).first()
    if user is None:
        raise HTTPException(status_code=401, detail="User not found")

    return user


# ====================== GET /wallet (ดูยอดเงิน) ======================

@router.get("/wallet", response_model=schemas.WalletResponse, dependencies=[Depends(security)])
def get_wallet(current_user: models.User = Depends(get_current_user)):
    return current_user.wallet



# ====================== POST /wallet/deposit ======================

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


# ====================== POST /wallet/withdraw ======================

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
