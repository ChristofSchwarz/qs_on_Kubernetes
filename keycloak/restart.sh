kubectl delete $(kubectl get pods -o=name|grep "nginx-ingress")
kubectl delete $(kubectl get pods -o=name|grep "edge-auth")
kubectl delete $(kubectl get pods -o=name|grep  "identity-providers")
