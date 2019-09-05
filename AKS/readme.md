# Installing QSEoK on Azure Kubernetes Services (AKS)
You need the Azure CLI. Open Powershell
```
az login
```
If you have more than one subscription, you can set a subscription to be the current active subscription by using:
```
az account set --subscription <subscription-id>
```
Enable AKS (Azure Kubernetes Service) for your Azure account
```
az provider register -n Microsoft.ContainerService
az provider register -n Microsoft.Compute
```
The above steps may take a couple of minutes you can check the provisioning using: 
```
az provider show -n Microsoft.ContainerService  --output table
az provider show -n Microsoft.Compute  --output table
```
Look for the registrationstate, you want it to be „Registered“

create a Resource Group (a logical container for different kinds of Azure resources, including AKS clusters). We use “rg-kubernetes” as the Resource Group Name (feel free to choose other locations than westeurope)
```
az group create --name rg-kubernetes --location westeurope
```
Check supported Kubernets versions for that location
```
az aks get-versions --location westeurope 
```

# Settings of Qlik Sense Enterprise on Kubernets in Azure Kubernetes Services (AKS)

Different settings files for your scenario. Apply with the following command
```
helm upgrade [RELEASE] [REPO]/qliksense -f qliksense.yaml
helm upgrade qliksense qlik-stable/qliksense -f qliksense.yaml
```
### qliksense.yaml
 * just a starting-point, will not work since no identity provider is specified
### qliksense2.yaml
 * built-in MongoDB (test only)
 * built-in OIDC listening to https://elastic.example (users need to set their hosts. file to login to QSEoK)
### qliksense3.yaml
 * built-in MongoDB (test only)
 * using Auth0 as IDP (identity provider) 
