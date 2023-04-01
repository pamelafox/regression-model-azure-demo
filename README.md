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

The function can be deployed using the [Azure Developer CLI](https://learn.microsoft.com/azure/developer/azure-developer-cli/overview). The `azd` CLI uses these files:

* `infra`:
  * `main.bicep`: Creates an Azure resource group and passes parameters to `resources.bicep`
  * `resources.bicep`: Creates a Function App, Storage account, App Service Plan, Log Analytics workspace, and Application Insights.
  * `main.parameters.json`: Describes parameters needed for `main.bicep`
* `azure.yaml`: Describes which code to upload to the Function App

Steps for deployment:

1. Sign up for a [free Azure account](https://azure.microsoft.com/free/)
2. Install the [Azure Dev CLI](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd).
3. Initialize a new `azd` environment:

    ```shell
    azd init
    ```

    It will prompt you to provide a name (like "modelfunc") that will later be used in the name of the deployed resources.

4. Provision and deploy all the resources:

    ```shell
    azd up
    ```

    It will prompt you to login, pick a subscription, and provide a location (like "eastus"). Then it will provision the resources in your account and deploy the latest code.

5. When `azd` has finished deploying, you'll see an endpoint URI in the command output. 

6. When you've made any changes to the app code, you can just run:

    ```shell
    azd deploy
    ```

## Feedback!?

If you have any issues going through this repository, you can use the *Discussions* tab on this repo.



