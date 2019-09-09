## run locally
Prerequesites:
 - You have NodeJS (and its package manager NPM) installed locally
 - You have access with helm to Qlik Sense Enterprise on Kubernetes in your Cluster, since you have to edit the "identityprovider" section

Open CMD or SH and navigate to this folder, where app.js is located. Run the following commands:
```
npm install
node app.js
```
A local web service will start. You can use curl or a web browser and navigate to http://localhost:31974/token 
Read on under "Using the webservice" to understand the parameters of it.

## run in Kubernetes
Prerequisites:
 - You have kubectl access to your Kubernetes cluster since we have to setup a secret, a pod, and a service
 - You have access with helm to Qlik Sense Enterprise on Kubernetes in your Cluster, since you have to edit the "identityprovider" section

1) Setup the secret
The priv.key file needs to be setup as a secret and it will be used by the NodeJS app in the pod rather than the priv.key file. It is recommened at this point that you created your own key pair (see above).
```
kubectl create secret generic qlikcustom-jwtkey --from-file priv.key
kubectl describe secret qlikcustom-jwtkey
```
2) Setup the pod
```
kubectl create -f getjwt-pod.yaml
kubectl describe pod qlikcustom-getjwt
```
In fact you could use the pod already with command line such as
```
kubectl exec qlikcustom-getjwt curl "http://localhost:31974/token"
```
However, to use it from a exposed web service, lets setup a service on top of it
3) Setup a service
You can choose between a NodePort service (use for Minikube) and a LoadBalancer (use in a managed Kubernetes scenario like Azure AKS).
### NodePort
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

### LoadBalancer
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

### uninstalling from Kubernetes
If you want to remove the objects, just use this to clean up:
```
kubectl delete service qlikcustom-getjwt-lb
kubectl delete service qlikcustom-getjwt-np
kubectl delete pod qlikcustom-getjwt
kubectl delete secret qlikcustom-jwtkey
```


## Using the webservice
This webservice will create a JWT token and respond it in a JSON response. 
