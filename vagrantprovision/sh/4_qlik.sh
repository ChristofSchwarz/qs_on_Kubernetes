#Install storageClass on NFS provider
helm install --name qmi stable/nfs-client-provisioner -f /vagrant/files/storageClass.yaml
