from pydantic import BaseModel, Field
from typing import Optional


# ====== User Models ======
class UserCreate(BaseModel):
    username: str = Field(..., min_length=3, max_length=50)
    password: str = Field(..., min_length=4, max_length=72)   # bcrypt limit


class UserLogin(BaseModel):
    username: str
    password: str = Field(..., max_length=72)  # bcrypt limit


class UserResponse(BaseModel):
    id: int
    username: str

    class Config:
        orm_mode = True


# ====== Token (JWT) ======
class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"


# ====== Wallet Models ======
class WalletResponse(BaseModel):
    balance: float

    class Config:
        orm_mode = True


class WalletAction(BaseModel):
    amount: float = Field(..., gt=0)
