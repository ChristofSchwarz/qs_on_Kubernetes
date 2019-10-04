echo 'executing "4_nfs.sh"'

echo 'Installing storageClass on NFS provider'
#Initialize Helm Tiller pod, upgrade and update the repos
helm init --wait --upgrade
helm repo update
helm install -n nfs stable/nfs-client-provisioner -f /vagrant/yaml/storageClass.yaml

echo 'Installing PVC on above storageClass'
kubectl apply -f /vagrant/yaml/pvc_nfs.yaml
