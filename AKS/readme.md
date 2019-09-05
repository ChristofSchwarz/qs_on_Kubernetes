# Settings of Qlik Sense Enterprise on Kubernets in Azure Kubernetes Services (AKS)

Different settings files for your scenario. Apply with the following command
```
helm upgrade [RELEASE] [REPO]/qliksense -f qliksense.yaml
helm upgrade qliksense qlik-stable/qliksense -f qliksense.yaml
```
## qliksense.yaml
 * just a starting-point, will not work since no identity provider is specified
## qliksense2.yaml
 * built-in MongoDB (test only)
 * built-in OIDC listening to https://elastic.example (users need to set their hosts. file to reach the cluster)
## qseok2.yaml
 * built-in MongoDB (test only)
 * built-in OIDC listening to whatever you like 
## qseok3.yaml
 * built-in MongoDB (test only)
 * using Auth0 as IDP (identity provider) 
