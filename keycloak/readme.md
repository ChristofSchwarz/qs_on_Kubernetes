# Using Keycloak as Identity Provider for QSEoK

The steps below will start keycloak as a K8s deployment and expose it as a service for your Minikube (NodePort). If deployed on a production cluster, you may need the service type "LoadBalancer". In this case, edit the `keycloak-svc.yaml` file first. 

The simpliest case is Keycloak *without* persistence. You will need two objects:
```
kubectl create -f keycloak-depl-nopersist.yaml -f keycloak-svc.yaml
```
If you want to persist the Keycloak settings (which I recommend), you have to first install a persisted Postgres DB:
```
kubectl create -f postgres-pvc.yaml -f postgres-depl.yaml -f postgres-svc.yaml
kubectl create -f keycloak-depl-persist.yaml -f keycloak-svc.yaml
```
![alttext](https://github.com/ChristofSchwarz/pics/raw/master/keycloak-opts.png "screenshot")

**Note:** Keycloak is a large deployment, it can take 10 min+ until it becomes ready. The command to check the status of just the keycloak pod is: wait until it is "Running"
```
kubectl get pod |grep keycloak
# or
kubectl get pod -o=custom-columns=:.status.phase --selector=app=keycloak --no-headers
```
Those reads helped me with setting up Keycloak on Postgres https://www.dirigible.io/blogs/2018/06/25/kubernetes_keycloak_postgresql_dirigible.html , https://severalnines.com/database-blog/using-kubernetes-deploy-postgresql , https://github.com/peterzandbergen/keycloak-kubernetes.


## Create a client on Keycloak to authenticate QSEoK users

### Manual steps
 * Navigate your browser to http://192.168.56.234:32080/auth/admin/master/console/#/create/client/master (thats the "Create Client" dialog in the Keycloak Administration Console)
 * Login with "admin" "admin"
 * Download this <a href="https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/keycloak/kc-client-settings.json">.json file</a> from this git, then click Import Select file from the Keycloak console.
 * This will create a new client called "qliklogin" (two Mappers have been added, too: name and email)
![alttext](https://github.com/ChristofSchwarz/pics/raw/master/_keycloak.png "screenshot") 
 * If your deployment is not on 192.168.56.234 please update the redirect_url of the new Keycloak client accordingly
 * Go to sheet "Credentials" and note the Secret-ID
 * Download this <a href="https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/keycloak/qliksense.yaml">.yaml file</a> and edit the Client-Secret before you apply the changes with "helm upgrade ..."

### Create the client with Keycloak REST API
 * Get an access token
```
curl -X POST https://192.168.56.234:32083/auth/realms/master/protocol/openid-connect/token -d 'username=admin&password=admin&client_id=admin-cli&grant_type=password' --insecure
```
... (to be completed) ...

## Upgrade Qlik Sense deployment (configure IDP)

It assumes Qlik Sense to be installed on IP 192.168.56.234 (the vagrant box we provisioned in this .git), if yours is different, pls edit the configuration first (redirect_url in the Keycloak Console and the qliksense.yaml file for helm upgrade ...)

```
helm upgrade --install qlik qlik-stable/qliksense -f qliksense.yaml
```
 * if you upgraded a Qlik Sense deployment (not first-time installed it now) then you have to manually restart the pod "qlik-identity-providers-#######":
```
kubectl delete pod --selector=app=identity-providers
```
 * you can now login to Qlik Sense with the keycloak user "admin" by going to https://192.168.56.234/ (because you already logged in, this happens without further prompting. You can check who you are logged in as by going to https://192.168.56.234/api/v1/users/me)
 * You can go to the Keycloak console and create more users, but none will be persisted if the keycloak pod is stopped.
 
## Remove Keycloak
To remove the deployment and the service, go
```
kubectl delete service keycloak-svc
kubectl delete deployment keycloak
kubectl delete service postgres-svc
kubectl delete deployment postgres
kubectl delete configmap postgres-config 
kubectl delete pvc pvc-postgres
```

# Using Helm to deploy keycloak

Found installation here https://github.com/codecentric/helm-charts
```
helm repo add codecentric https://codecentric.github.io/helm-charts
helm install -n keycloak codecentric/keycloak --set keycloak.service.type=NodePort --set keycloak.service.nodePort=32080
```
All other settings you can pass (with --set or in a .yaml file) explained here:
https://github.com/codecentric/helm-charts/tree/master/charts/keycloak

Without further configuration, also this helm deployment won't persist (it starts a separate postgres-db though). Let me 
know if you managed a setup that persists, so I can share ...



# Errors 
The configuration of the identity-provider can lead to some error messages by Qlik Sense:
```
{"errors":[{"title":"No authentication configured for this hostname","code":"LOGIN-2","status":"401"}]}
{"errors":[{"title":"Invalid identity provider configuration","code":"INVALID-IDP-CONFIG","status":"401"}]}
```


