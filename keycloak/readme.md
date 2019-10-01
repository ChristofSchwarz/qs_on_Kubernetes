# Using Keycloak as Identity Provider for QSEoK

Warning: No config change you set in the Keycloak instance will persist (restarting the pod flushes all setup!)

You can start the keycloak image as a deployment and add a service around it for your Minikube with below commands.

If you downloaded both yaml files from this git, go:
```
kubectl create -f keycloak-depl.yaml
kubectl create -f keycloak-svc.yaml
```
Or you can directly start them from my git
```
kubectl create -f https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/keycloak/keycloak-depl.yaml
kubectl create -f https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/keycloak/keycloak-svc.yaml
```
To remove the deployment and the service, go
```
kubectl delete service keycloak
kubectl delete deployments keycloak
```
