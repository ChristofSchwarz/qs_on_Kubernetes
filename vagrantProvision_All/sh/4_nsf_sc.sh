echo 'executing "4_nsf_sc.sh"'

#Install storageClass on NFS provider
helm install -n nfs stable/nfs-client-provisioner -f /vagrant/files/storageClass.yaml
