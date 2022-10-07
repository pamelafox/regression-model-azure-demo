import json

import azure.functions as func
import joblib
import numpy as np

def get_param(req, param_name):
    param_value = req.params.get(param_name)
    if not param_value:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            param_value = req_body.get(param_name)
    return param_value


def main(req: func.HttpRequest) -> func.HttpResponse:
    loaded_model = joblib.load('yearly-comp.pkl')
    X_new = np.array([[8, 6, 'Bachelor’s degree (B.A., B.S., B.Eng., etc.)','I am a developer by profession', 'Employed, full-time', 'United States of America']])
    result = loaded_model.predict(X_new)
    return func.HttpResponse(json.dumps({"salary": result[0]}))