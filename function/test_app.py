from fastapi.testclient import TestClient

from . import app

client = TestClient(app)


def test_model_predict():
    response = client.get(
        "/model_predict",
        params={
            "years_coding": 8,
            "years_coding_pro": 6,
            "education_level": "Bachelor’s degree (B.A., B.S., B.Eng., etc.)",
            "developer_status": "I am a developer by profession",
            "country": "United States of America",
        },
    )
    assert response.status_code == 200
    assert response.json() == {"salary": 135877.97}
