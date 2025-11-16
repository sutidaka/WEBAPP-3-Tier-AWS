from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer
from fastapi.openapi.utils import get_openapi

from app import database, auth, wallet
from app.database import get_db

app = FastAPI(title="Mini Wallet API")

# Enable JWT Bearer Security
bearer_scheme = HTTPBearer()

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


# -------------------------------
#  Add JWT Bearer to Swagger UI
# -------------------------------
def custom_openapi():
    if app.openapi_schema:
        return app.openapi_schema

    openapi_schema = get_openapi(
        title="Mini Wallet API",
        version="1.0.0",
        description="Mini E-Wallet Application API",
        routes=app.routes,
    )

    openapi_schema["components"]["securitySchemes"] = {
        "BearerAuth": {
            "type": "http",
            "scheme": "bearer",
            "bearerFormat": "JWT"
        }
    }

    app.openapi_schema = openapi_schema
    return app.openapi_schema