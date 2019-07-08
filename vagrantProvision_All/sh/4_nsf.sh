echo 'executing "4_nsf.sh"'

echo 'Installing storageClass on NFS provider'
helm install -n nfs stable/nfs-client-provisioner -f /vagrant/files/storageClass.yaml

echo 'Installing PVC on above storageClass'
kubectl apply -f /vagrant/files/pvc_nfs.yaml
