 # Installing Qlik Sense Enterprise on Minikube
 
 This uses the free software Vagrant and VirtualBox to provision a Virtual Machine and installs Minikube 
 in a way to allow Qlik Sense Enterprise on Kubernetes to run on top of it.
 
 After you downloaded (and unzipped) this git, open a Command Prompt and navigate to the vagrantprovision folder
``` 
cd .\vagrantprovision
vagrant box add ""
vagrant up
```
If you want to stop and remove the VM properly (also if you want to restart the provisioning process), type
```
vagrant destroy
```

