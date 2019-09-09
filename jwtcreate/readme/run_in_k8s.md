
## Run in Kubernetes
Prerequisites:
 - You already edited the "identity-provider" configuration and applied it with "helm upgrade" as described in the main <a href="https://github.com/ChristofSchwarz/qs_on_Kubernetes/blob/master/jwtcreate/readme.md">readme</a>
 - You have kubectl access to your Kubernetes cluster using kubectl since we have to setup a secret, a pod, and a service


### Setup the secret
The priv.key file needs to be setup as a secret and it will be used by the NodeJS app in the pod rather than the priv.key file. It is recommened at this point that you created your own key pair (see above).
```
kubectl create secret generic qlikcustom-jwtkey --from-file priv.key
kubectl describe secret qlikcustom-jwtkey
```
### Setup the pod
```
kubectl create -f getjwt-pod.yaml
kubectl describe pod qlikcustom-getjwt
```
In fact you could use the pod already direclty without a service, using a command line such as
```
kubectl exec qlikcustom-getjwt curl "http://localhost:31974/token?..."
```
However, to use it from ousside, lets setup a service on top of it

### Setup a service

You can choose between a NodePort service (use for Minikube) and a LoadBalancer (use in a managed Kubernetes scenario like Azure AKS).

#### NodePort Service
```
kubectl create -f getjwt-svc-np.yaml
kubectl get svc qlikcustom-getjwt-np
```
You should see something like this
```
NAME                   TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)         
qlikcustom-getjwt-np   NodePort   10.0.184.105   <none>        31974:31975/TCP 
```
Navigate to your clusters main external address. In case of Minikube it is the one that the VM has got (yes, it is port 31975 not 31974 when using NodePort). Try curl http://192.168.56.71:31975/token

#### LoadBalancer Service
In a managed Kubernetes Scenario (Azure AKS, ...) you would expose the service to be accessible from internet.
```
kubectl create -f getjwt-svc-lb.yaml
kubectl get service qlikcustom-getjwt-lb
```
Wait a minute for a public IP address to be assigned. Once ready you can see it in the "describe svc" section:
```
NAME                                    TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)
qlikcustom-getjwt-lb                    LoadBalancer   10.0.36.192    51.140.253.101   31974:31975/TCP
```
In above example the service is now available here: http://51.140.253.101:31974/token 

### Uninstalling from Kubernetes
If you want to uninstall this app, remove the objects using below commands:
```
kubectl delete service qlikcustom-getjwt-lb
kubectl delete service qlikcustom-getjwt-np
kubectl delete pod qlikcustom-getjwt
kubectl delete secret qlikcustom-jwtkey
```
Now learn how to <a href="https://github.com/ChristofSchwarz/qs_on_Kubernetes/blob/master/jwtcreate/readme/webservice.md">use this webservice</a>

