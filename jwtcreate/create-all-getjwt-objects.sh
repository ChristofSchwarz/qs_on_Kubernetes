kubectl create secret generic qlikcustom-jwtkey --from-file priv.key
kubectl create -f getjwt-pod.yaml
kubectl create -f getjwt-svc-np.yaml
