# Using Keycloak as Identity Provider for QSEoK

Warning: No config change you set in the Keycloak instance will persist (restarting the pod flushes all setup!)

You can start the keycloak image as a deployment and add a service around it for your Minikube with below commands. In order to work in Minikube I set the service type to "NodePort". If deployed on a production cluster, you may need type "LoadBalancer". In this case, edit the keycloak-svc.yaml first.

If you downloaded the yaml file from this git, go:
```
kubectl create -f keycloak-depl+svc.yaml
```
Or you can directly start them from my git
```
kubectl create -f https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/keycloak/keycloak-depl+svc.yaml
```

## Create a client on Keycloak to authenticate QSEoK users

 * Navigate your browser to <a href="http://192.168.56.234:32080/auth/admin/master/console/#/create/client/master" target="_blank">`http://192.168.56.234:32080/auth/admin/master/console/#/create/client/master`</a>
 * Login with "admin" "admin"
 * Download this <a href="https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/keycloak/kc-client-settings.json">.json file</a> from this git, then click Import Select file from the Keycloak console.
 * This will create a new client called "qliklogin" (two Mappers have been added, too: name and email)
 * Go to sheet "Credentials" and note the Secret-ID
 * Download this <a href="https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/keycloak/qliksense.yaml">.yaml file</a> and edit the Client-Secret before you apply the changes with "helm upgrade ..."
```
helm upgrade --install qlik qlik-stable/qliksense -f qliksense.yaml
```
 * you can now login to Qlik Sense with the keycloak user "admin" by going to <a href="https://192.168.56.234/" target="_blank">`https://192.168.56.234/`</a>
 * You can go to the Keycloak console and create more users, but none will be persisted if the keycloak pod is stopped.
 
## Remove Keycloak
To remove the deployment and the service, go
```
kubectl delete service keycloak
kubectl delete deployment keycloak
```


# Using Helm to deploy keycloak

Found installation here https://github.com/codecentric/helm-charts
```
helm repo add codecentric https://codecentric.github.io/helm-charts
helm install -n keycloak codecentric/keycloak --set keycloak.service.type=NodePort --set keycloak.service.nodePort=8080
```
All other settings you can pass (with --set or in a .yaml file) explained here:
https://github.com/codecentric/helm-charts/tree/master/charts/keycloak

