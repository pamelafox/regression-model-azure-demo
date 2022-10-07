import azure.functions as func

app = func.FunctionApp()

@app.function_name(name="SalaryModel")
@app.route(route="salary_model") # HTTP Trigger
def test_function(req: func.HttpRequest) -> func.HttpResponse:
    loaded_model = joblib.load(filename)
    # parameters for each of them
    X_new = np.array([[8, 6, 'Bachelor’s degree (B.A., B.S., B.Eng., etc.)','I am a developer by profession', 'Employed, full-time', 'United States of America']])
    result = loaded_model.predict(X_new)
    return func.HttpResponse(result)