# Qlik Sense Enterprise on Kubernetes

The attached <a href="https://github.com/ChristofSchwarz/qs_on_Kubernetes/blob/master/QSEonK8s%20Logs.qvf?raw=true">.qvf app</a> connects to the Kubernetes API to read the name of the pods and 
 - computes the actual deeplink to the log of the container(s) in the pod
 - imports some of the logs directly into the app

Current version: __0.12__

Currently I import those logs: engine, edge-auth

 To enable the Kubernetes API in your cluster with this command
```
kubectl proxy --address='ip.of.the.host' --port=8001 --accept-hosts='browser.url.of.k8s'
```

 * The hostname, port must also be set in the Load Script of the app (page Main).
 * If the REST connector configuration is missing after import, just create a new "GET" Rest Connection to any url for example https://jsonplaceholder.typicode.com/todos/1 , no authentication. Correct the statement on page "Main" in the script where it reads LIB CONNECT TO 'your_new_REST_conn';


![alttext](https://github.com/ChristofSchwarz/pics/raw/master/k8slog1.png "screenshot")

More and more log tables will be added, like the below

![alttext](https://github.com/ChristofSchwarz/pics/raw/master/k8slog2.png "screenshot")


