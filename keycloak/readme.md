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
To remove the deployment and the service, go
```
kubectl delete service keycloak
kubectl delete deployment keycloak
```
Navigate your browser to http://192.168.56.234:32080 





# Using Helm to deploy keycloak

Found installation here https://github.com/codecentric/helm-charts
```
helm repo add codecentric https://codecentric.github.io/helm-charts
helm install -n keycloak codecentric/keycloak --set keycloak.service.type=NodePort --set keycloak.service.nodePort=8080
```
All other settings you can pass (with --set or in a .yaml file) explained here:
https://github.com/codecentric/helm-charts/tree/master/charts/keycloak

