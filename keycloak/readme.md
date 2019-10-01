# Using Keycloak as Identity Provider for QSEoK

**Warning: No config change you set in the Keycloak instance will persist (restarting the pod flushes all setup!) Use this for a quick test only. Below steps are just the absolute minimum to get it run.**

The steps below will start keycloak as a K8s deployment and expose it as a service for your Minikube (NodePort). If deployed on a production cluster, you may need the service type "LoadBalancer". In this case, edit the keycloak-depl+svc.yaml file first.

If you downloaded the yaml file from this git, go:
```
kubectl create -f keycloak-depl+svc.yaml
```
Or you can directly create the objects from a url to my git
```
kubectl create -f https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/keycloak/keycloak-depl+svc.yaml
```

## Create a client on Keycloak to authenticate QSEoK users

 * Navigate your browser to http://192.168.56.234:32080/auth/admin/master/console/#/create/client/master (thats the "Create Client" dialog in the Keycloak Administration Console)
 * Login with "admin" "admin"
 * Download this <a href="https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/keycloak/kc-client-settings.json">.json file</a> from this git, then click Import Select file from the Keycloak console.
 * This will create a new client called "qliklogin" (two Mappers have been added, too: name and email)
![alttext](https://github.com/ChristofSchwarz/pics/raw/master/_keycloak.png "screenshot") 
 * Go to sheet "Credentials" and note the Secret-ID
 * Download this <a href="https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/keycloak/qliksense.yaml">.yaml file</a> and edit the Client-Secret before you apply the changes with "helm upgrade ..."
```
helm upgrade --install qlik qlik-stable/qliksense -f qliksense.yaml
```
 * if you upgraded a Qlik Sense deployment (not first-time installed it now) then you have to manually restart the pod "qlik-identity-providers-#######":
```
kubectl delete $(kubectl get pods -o=name|grep "identity-providers")
```
 * you can now login to Qlik Sense with the keycloak user "admin" by going to https://192.168.56.234/ (because you already logged in, this happens without further prompting. You can check who you are logged in as by going to https://192.168.56.234/api/v1/users/me)
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
helm install -n keycloak codecentric/keycloak --set keycloak.service.type=NodePort --set keycloak.service.nodePort=32080
```
All other settings you can pass (with --set or in a .yaml file) explained here:
https://github.com/codecentric/helm-charts/tree/master/charts/keycloak

Without further configuration, also this helm deployment won't persist (it starts a separate postgres-db though). Let me 
know if you managed a setup that persists, so I can share ...

