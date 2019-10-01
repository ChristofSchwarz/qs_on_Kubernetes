# Using Keycloak as Identity Provider for QSEoK

You can start the keycloak image as a deployment and add a service around it for your Minikube like this:
```
kubectl create -f https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/keycloak/keycloak-depl.yaml
kubectl create -f https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/keycloak/keycloak-svc.yaml
```
Warning: No config change you set in the Keycloak instance will persist (restarting the pod flushes all setup!)
