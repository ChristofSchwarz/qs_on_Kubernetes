 # Installing Qlik Sense Enterprise on Minikube
 
 This uses the free software Vagrant and VirtualBox to provision a Virtual Machine and installs Minikube (a non-production single-node Kubernetes) in a way to allow Qlik Sense Enterprise on Kubernetes to run on top of it.
 
 ## How to provision 

You need to install 

 - Oracle VirtualBox 6.X or later from https://www.virtualbox.org/
 - Vagrant 2.2 or later from https://www.vagrantup.com/ <br/>(Note if prompted where to install leave the default C:\HarshiCorp !)
 
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
Type "exit" to get back from bash of the Ubuntu into your host system prompt.

If you want to stop and remove the VM properly (also if you want to restart the provisioning process), type
```
vagrant destroy
```

 ## Configuration

You can see <a href="https://github.com/ChristofSchwarz/qs_on_Kubernetes/blob/master/vagrantprovision/Vagrantfile">here the settings</a> for this virtual machine. It uses Ubuntu 16.04, 6 GB or RAM, 2 processors, and syncs the relative folder "/files" within the VM as "/vagrant/files" folder. You will find the config files (.yaml) there.

The scripts which will be processed right after the first boot of the machine are found in <a href="https://github.com/ChristofSchwarz/qs_on_Kubernetes/tree/master/vagrantprovision/sh">subfolder sh</a>. They install NFS, Docker, Docker Machine, Minikube, kubeadm, kubectl, helm.

You will have a blank but working minikube. The essential parts to install a storageClass, a PVC, NFS-Container, MongoDB, Qlik Sense init and Qlik Sense are found in <a href="https://github.com/ChristofSchwarz/qs_on_Kubernetes/blob/master/vagrantprovision/sh/4_qlik.sh">file 4_qlik.sh</a> which will not automatically be started. 

If you do it first time, I remcommend to copy/paste and try to understand every line of this script to understand whats done. If you want to shortcut, execute the .sh file with 
```
bash /vagrant/files/4_qlik.sh
```

Enjoy QSEonK8s
