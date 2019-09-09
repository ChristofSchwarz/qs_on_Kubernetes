 ## The idea
This minimalistic NodeJS app creates a signed JWT token which can work as Bearer Authentication in Qlik Sense Enterprise on Kubernetes. It allows you to **impersonate as the user you want** and to automate API calls that otherwise are not possible. Handle with caution.
You can do this directly using https://jwt.io if you provide the relevant JWT header-keys and JWT payload entries. In this case, you don't have to use my NodeJS app. Create the key pair (next section) and then continue to read at "Using JWT.IO" then.

This tool runs in two different modes
 - locally (you will need nodejs and npm installed)
 - as Kubernetes Pod (you need to have kubectl access to your Kubernetes cluster)
To get started download this entire folder (get the whole git and use folder “jwtcreate”)
## Create public and private SSH key pair
If you want to skip this step for a quick test, you may use the attached priv.key and pub.key although this compromises your security!
Any SSH key pair would work. To create a new one (under Linux) execute these commands
```
openssl genrsa -out priv.key 4096
openssl rsa -in priv.key -pubout -out pub.key
```
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
## Using JWT.IO
This is an alternative way to create a JWT token, but you have to copy/paste quite some information for each token.
 - Go to https://jwt.io
 - Paste this into the "HEADER" field:
 ```
 ```
 - Paste this into the "PAYLOAD DATA" field:
 ```
 ```
 - Paste the content of your pub.key into the first field of "VERIFY SIGNATURE"
 - Paste the content of your priv.key into the second field of "VERIFY SIGNATURE"

## Configure QSEoK Identity provider
Edit the .yaml file which you last used to install or upgrade your Qlik Sense Enterprise on Kubernetes with helm. If you are not certain what the last helm configuration was, use this command to create a current qliksense.yaml file: (qlik in below example is the name of the deployment, yours could be different such as qliksense or qseok)
```
helm get values qlik >qliksense.yaml
``` 
Edit the .yaml and find the section for "identity-providers". You should find a section "identity-providers" already, otherwise your QSEoK installation is not ready to be used yet. There is already a "hostname" configured within that section. Remember that one and use the same hostname, when you insert the text below. There are 4 very important settings:
 * hostname -> this defines which tenant the user is assigned to. Use the same hostname as the one you already had 
 * realm -> this defines the "part before the \" of the userid. Use the same as you already had
 * kid -> choose one and use it later in the webservice or on jwt.io
 * pem -> The content of your pub.key file has to go in here

The yaml file should look like this (adjust hostname, realm, kid, and pem accordingly)
```
identity-providers:
  secrets:
    idpConfigs:
      - hostname: "51.141.29.221"
        realm: "Auth0" #
        primary: false
        issuerConfig:
          issuer: "https://qlik.api.internal"
        staticKeys:
        - kid: "my-key-identifier"
          pem: |-
            -----BEGIN PUBLIC KEY-----
            MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEApcxutPf8kK6TK4cX4abY
            EArPDVngZBqww7H9tOWhU+micMkRMQhyMnxYFhPIF/BHrdDQ5ph8W6zzggVyk8k+
            WiY/BHec3nGIgoXbe/5K45ChJhhrMj9CCJqHd1Q3stxfEMkwWupiJ8DDsUgqMfVz
            t8ufBiKtnLw5v51T6+8Or9TgZ5L+vnAc+uW5RbDT5iAPT2Zqapk4aYU4B9bVY0t0
            D5T2s56HmdzTYG8OvUsjdkMRUGvZmD358upX0jG0sRdQZC68Ej92yMZNJFZh+w+E
            9Q525ZNah4piioP/4714FAfjh8rU0T1ndrXbhgyWHbTXRlLJ8B4oyFgi+XyjFZLP
            hwOp25QMV08t2Lwn4g8aMW7lz0jYSTSETJF6rWIspwc7iSQ6KNtogJyyphxIRi2E
            XXgPJScSf8YeGDqFYXaGd4ysoRWgOKnEY69dYRT805YzGpr6NLcXZJ3SMYoJS6NI
            1OAlOSUdRCLWs67WtlHb3g1zCD20/0AV8TAo7Yvah2WKzBtKnDzQNKa/RK5ahQ+a
            +O692il39bR/3E+EEvBseCLwqhJpyJ5IgXjFiIAj56mdbSMj8xRof/mrYN2ofr2A
            4zl7HanxuF79w+G70RE9Y7my4zA9jlAFyVABD8Iuee+sSh8OQXMqLCa+8wmgrejC
            SJxIUvPgQpuWgVRrDQMHobMCAwEAAQ==
            -----END PUBLIC KEY-----
```
Then apply the new setting with this command. Note "qlik" and "qlik-stable" may be called differently.
```
helm upgrade --install qlik qlik-stable/qliksense -f qliksense.yaml
```
## Using the webservice
This webservice will create a JWT token and respond it in a JSON response. 
