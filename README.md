# Qlik Sense Enterprise on Kubernetes

The attached .qvf app connects to the Kubernetes API to read the name of the pods and 
 - computes the actual deeplink to the log of the pod
 - imports some of the logs directly into the app

Currently I import those logs: engine, edge-auth

 To enable in your cluster with this command
^^^
kubectl proxy --address='$(vHost)' --port=$(vPort) --accept-hosts='^$(vHost)$'
^^^

The hostname, port must also be set in the Load Script of the app (page a).

![alttext\](https://github.com/ChristofSchwarz/pics/raw/master/k8slog1.png "screenshot")

More and more log tables will be added, like the below

![alttext\](https://github.com/ChristofSchwarz/pics/raw/master/k8slog2.png "screenshot")


