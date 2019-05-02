 # Installing Qlik Sense Enterprise on Minikube
 
 This uses the free software Vagrant and VirtualBox to provision a Virtual Machine and installs Minikube (a non-production single-node Kubernetes) in a way to allow Qlik Sense Enterprise on Kubernetes to run on top of it.
 
 ## How to provision 

You need to install 

 - Oracle VirtualBox 6.X or later from https://www.virtualbox.org/
 - Vagrant 2.2 or later from https://www.vagrantup.com/ <br/>(Note if prompted where to install leave the default C:\HarshiCorp !)

For simplicity reasons, this installation of QSEonK8s will use the built-in user authentication (no 3rd-party Identity Provider). 
You must access the portal using https://elastic.example:32443 therefore add this (or update) your hosts file found in c:\windows\System32\drivers\etc with this entry:
```
192.168.56.234 elastic.example
```
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

You can see <a href="https://github.com/ChristofSchwarz/qs_on_Kubernetes/blob/master/vagrantprovision/Vagrantfile">here the settings</a> for this virtual machine. It uses 
 * Ubuntu 16.04
 * 6 GB RAM
 * 2 processors
 * syncs the relative folder "/files" within the VM as "/vagrant/files" folder (You will find the .yaml config files there) 
 * sets root user to __vagrant__ password __vagrant__

The scripts which will be processed right after the first boot of the machine are found in <a href="https://github.com/ChristofSchwarz/qs_on_Kubernetes/tree/master/vagrantprovision/sh">subfolder 'sh'</a>. They install NFS, Docker, Docker Machine, Minikube, kubeadm, kubectl, helm.

You will have a blank but working minikube. The essential parts to install a storageClass, a PVC, NFS-Container, MongoDB, Qlik Sense init and Qlik Sense are found in <a href="https://github.com/ChristofSchwarz/qs_on_Kubernetes/blob/master/vagrantprovision/sh/4_qlik.sh">file 4_qlik.sh</a> which will not automatically be started. 

If you do it first time, I recommend to copy/paste every line of 4_qlik.sh one by one and try to understand what it does. If you want to shortcut, execute the .sh file with 
```
bash /vagrant/files/4_qlik.sh
```
 ## First Time Login, Enter License
 
Once all pods are running (check with: kubectl get pods) you can navigate your browser to https://elastic.example:32443/console . If everything is correct you will be redirected to port :32123 for login. Choose one of the users below. Remember: the first one to log in to a fresh installation will be site administrator.
  
 * harley@qlik.example, password "Password1!"
 * barb@qlik.example, password "Password1!"
 * sim@qlik.example, password "Password1!"	

Next you will get back to https://elastic.example:32443/console where you'll have a box to enter the site license (a JWT token you got from your Qlik representative). Once applied, you may see "unauthorized" and may have to re-login. That is only once after the site license has been set. 

https://elastic.example:32443/explore will show the new hub. You can create or upload apps there.

Enjoy QSEonK8s

 ## Known Issues
 
 - The first time you try to enter the console on https://elastic.example:32443/console the browser gets redirected to https://elastic.example/console/ and fails. -> Enter the port :32443 again and it will work
 - This configuration has issues accessing the scheduled tasks (https://elastic.example:32443/console/scheduler/)
 - Logout returns "OK" but doesn't remove the cookie. The session is still alive. Use Incognito Mode or delete the Cookie in the Developer tools of your browser.

