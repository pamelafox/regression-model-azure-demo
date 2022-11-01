# Building a regression model and deploying to Azure

This repository was built for a #30DaysOfDataScience talk that demonstrates how to build a regression model using sci-kit learn and then deploy it as an HTTP API to Azure Functions.

Technologies used: Jupyter notebook, pandas, scikit-learn, numpy, matplotlib, joblib, Azure functions, Azure Developer CLI, FastAPI

## The slides

The slides are viewable online here:
[tinyurl.com/regression-slides](https://pamelafox.github.io/regression-model-azure-demo/notebook/)

The slides are generated using a Github action that runs `nbconvert` on `notebook/index.ipynb`.
Locally, you can use [RISE](https://rise.readthedocs.io/en/stable/) to view the notebook as slides.

## The function

The `function` folder contains the code necessary to turn the pickled regression model into an Azure function:

* `__init__.py`: The main Python code that uses FastAPI to setup the `model_predict` API endpoint
* `categories.py`: The values of the enums for `model_predict` (generated from the `categorical features` in the notebook)
* `model.pkl`: The pickled regression model
* `function.json`: Configuration JSON needed for Azure functions

## Deployment

The function can be deployed using the [Azure Developer CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/overview?WT.mc_id=python-79071-pamelafox). The `azd` CLI uses these files:

* `infra`:
  * `main.bicep`: Creates an Azure resource group and passes parameters to `resources.bicep`
  * `resources.bicep`: Creates a Function App, Storage account, App Service Plan, Log Analytics workspace, and Application Insights.
  * `main.parameters.json`: Describes parameters needed for `main.bicep`
* `azure.yaml`: Describes which code to upload to the Function App

To deploy the code, download the `azd` CLI and run:

```shell
azd up
```

It will prompt you to login and to provide a name (like "salary-model") and location (like "centralus"). Then it will provision the resources in your account (if they don't yet exist) and deploy the latest code.

When you've made any changes to the function, you can just run:

```shell
azd deploy
```


## Feedback!?

If you have any issues going through this repository, you can use the discussions tab on this repo or tweet at @pamelafox.



