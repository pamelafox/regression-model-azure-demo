import azure.functions
import fastapi
import joblib
import nest_asyncio
import numpy

import categories

app = fastapi.FastAPI()
nest_asyncio.apply()
model = joblib.load("function/yearly-comp.pkl")

@app.get("/model_predict")
async def model_predict(
    years_coding: int,
    years_coding_pro: int,
    education_level: categories.EdLevel,
    developer_status: categories.MainBranch,
    country: categories.Country,
):
    
    X_new = numpy.array(
        [
            [
                years_coding,
                years_coding_pro,
                education_level.value,
                developer_status.value,
                country.value,
            ]
        ]
    )
    result = model.predict(X_new)
    return {"salary": round(result[0], 2)}


async def main(
    req: azure.functions.HttpRequest, context: azure.functions.Context
) -> azure.functions.HttpResponse:
    return azure.functions.AsgiMiddleware(app).handle(req, context)
