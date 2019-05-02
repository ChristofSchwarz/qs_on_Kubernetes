 # Installing Qlik Sense Enterprise on Minikube
 
 This uses the free software Vagrant and VirtualBox to provision a Virtual Machine and installs Minikube 
 in a way to allow Qlik Sense Enterprise on Kubernetes to run on top of it.
 
 After you downloaded (and unzipped) this git, open a Command Prompt and navigate to the vagrantprovision folder.
 Follow those vagrant commands. We start based on a Ubuntu Xenial base box and then provision what is stated in the "Vagrantfile" 
 file and the /sh subfolder
``` 
cd .\vagrantprovision
vagrant box add "bento/ubuntu-16.04"
vagrant up
```
wait 1 hour or so for all the packages to deploy. To get a terminal window type
```
vagrant ssh
```
If you want to stop and remove the VM properly (also if you want to restart the provisioning process), type
```
vagrant destroy
```

