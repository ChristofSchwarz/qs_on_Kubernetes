## Installing QSEoK on Azure Kubernetes Services (AKS)
You need the Azure CLI. Open Powershell
```
az login
```
If you have more than one subscription, you can set a subscription to be the current active subscription by using:
```
az account set --subscription <subscription-id>
```
Enable AKS (Azure Kubernetes Service) for your Azure account
```
az provider register -n Microsoft.ContainerService
az provider register -n Microsoft.Compute
```
The above steps may take a couple of minutes you can check the provisioning using: 
```
az provider show -n Microsoft.ContainerService  --output table
az provider show -n Microsoft.Compute  --output table
```
Look for the registrationstate, you want it to be „Registered“

create a Resource Group (a logical container for different kinds of Azure resources, including AKS clusters). We use “rg-kubernetes” as the Resource Group Name (feel free to choose other locations than westeurope)
```
az group create --name rg-kubernetes --location westeurope
```
Check supported Kubernets versions for that location
```
az aks get-versions --location westeurope 
```
Decide your version of kubernetes to install. I used "1.13.10". Remember that version as you need to download the corresponding kubectl.exe and in the next steps!

Create the cluster named "cl-kubernetes" in the resource group "rg-kubernetes" in the given version, given number of nodes and vm-size
```
az aks create  --resource-group rg-kubernetes --name cl-kubernetes --node-count 3  --generate-ssh-keys  --kubernetes-version 1.13.10  --node-vm-size Standard_DS2_v2
```
This can take up to 15 minutes

To get the credentials for accessing the cluster and to configure kubectl to communicate with it, run
```
az aks get-credentials --resource-group=rg-kubernetes --name=cl-kubernetes
```
This command writes the connection parameter to the config file located in %userprofile%\.kube. 

Create a storage account to store files. To find the corresponding cluster Resource Group do:
```
az group list -o table
```
Look for the right resource group, it is the one starting with MC_rg-kubernetes_cl-kubernetes_xxx and adjust the next command (where it reads westeurope) and also choose a unique accountname (here "account1")
```
az storage account create -g MC_rg-kubernetes_cl-kubernetes_westeurope -n account1 --sku Standard_LRS
```


## Installing kubectl for Powershell

 * create folder C:\Kubernetes and navigate to that folder
 * Remember the version of Kubernetes which you installed before and adjust the link below if yours is different than v1.13.10
 * Download kubectl from 
https://storage.googleapis.com/kubernetes-release/release/v1.10.13/bin/windows/amd64/kubectl.exe into C:\Kubernetes
 * kubectl.exe should now be available in C:\Kubernetes. You may want add C:\Kubernetes to the „PATH“ variable of Windows, so that you can type the kubectl command from within other folder in Powershell or Cmd. If not, you will have to use ".\kubectl" instead of "kubectl" in all the following commands in order to call the local kubectl.exe from the current folder

See if your context of kubectl is our (new) cluster
```
kubectl config current-context
```
If your context isn't "cl-kubernetes", the cluster we just created, pick it with this command
```
kubectl config set-cluster cl-kubernetes
```
You can see which other clusters (if so) you can connect to by using 
```
kubectl config get-clusters 
```
## Configure AKS for first use
AKS offers two types of file storage, however, the default (Azure Disk) does not support ReadWriteMany which is required for QSEoK to provide persisted storage across multiple nodes. Instead, Azure File Share should be used.
```
kubectl create clusterrole system:azure-cloud-provider --verb=get,create --resource=secrets
```
Bind the cluster role
```
kubectl create clusterrolebinding system:azure-cloud-provider --clusterrole=system:azure-cloud-provider --serviceaccount=kube-system:persistent-volume-binder
```
Create a storage-class from this <a href="https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/AKS/storageclass.yaml">yaml-file</a> using this command
```
kubectl apply -f https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/AKS/storageclass.yaml
```
(Alternatively, you can also download the file and use it in the -f parameter locally)

## Installing and configuring helm

 * Open download page: https://github.com/helm/helm/releases
 * Download one of the latest stable releases, the link is found when you scroll down, for example https://get.helm.sh/helm-v2.14.3-windows-amd64.zip
 * open the .zip when downloaded and copy helm.exe and tiller.exe into your working folder C:\Kubernetes
 * you should be able to execute the command "helm" now (if it isn't in your PATH, you will have to use ".\helm" to call the local helm.exe from the current folder)
You are now done setting up helm, the next steps are to configure it for AKS

Lets install the "tiller pod" in the cluster and upgrade to the latest version
```
helm init --upgrade --wait  
```
AKS is provisioned with RBAC (Role Based Access Control) enabled. In order for HELM to successfully operate in an RBAC enabled cluster a service account needs to be created from this <a href="https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/AKS/serviceaccount.yaml">yaml-file</a>
```
kubectl create -f https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/AKS/serviceaccount.yaml
```
(Alternatively, you can also download the file and use it in the -f parameter locally)

Tell helm to use the newly created ServiceAccount
```
helm init --upgrade --service-account tiller  
```
To get a list of all configured repositories from helm use
```
helm repo list
```
To add Qlik’s repositories to helm use:
```
helm repo add qlik-stable https://qlik.bintray.com/stable
helm repo add qlik-edge https://qlik.bintray.com/edge
```
To see which charts are the latest ones in the repos, use
```
helm search qlik-stable
helm search qlik-edge
```
or get a list of all available versions
```
helm search qlik-stable --versions
helm search qlik-edge --versions
```
## Deploy QSEoK first time
Use the following helm commands to deploy QSEoK, download this <a href="https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/AKS/qliksense.yaml">qliksense.yaml file</a> from this github into your current folder. The deployment installs a customresourcedefinition first (qliksense-init) and then the qliksense chart. (you can choose below between qlik-stable or qlik-edge repo, just as we added it with "helm repo add" before)
```
helm install --name qlik-init qlik-stable/qliksense-init
helm install --name qlik qlik-stable/qliksense -f qliksense.yaml
```
This will take quite some time (min 20 min) to pull about 60 container-images. From time to time check
```
kubectl get pods
```
and wait until all are running. Don't worry, if some pods are crashing while others are still creating.

Lets find out the IP address of our new QSEoK cluster:
```
kubectl get service -l app=nginx-ingress
```
It will list the EXTERNAL-IP of type Load-Balancer. You can navigate to this with your browser (https://51.140.243.233), if all has worked out, you will see a certificate warning and then run into an error, because we haven't setup an identity provider yet.

We will shift gears now and download another <a href="https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/AKS/qliksense3.yaml">yaml file</a> to your working folder. This configuration which tell QSEoK 
 - to use <a href="https://auth0.com/">Auth0</a> (a cloud idp, free accounts are available) 
 - tell the MongoDB where to persist (otherwise if qlik-mongodb gets killed, all site configuration is lost with it.
 - Important! Edit the downloaded file with a text-editor (notepad) and replace the ip address to the one you have got (section identity-providers)
 
Since we installed the chart "qlik" already, this time it is "helm upgrade", not "helm install". The 
```
helm upgrade qlik qlik-stable/qliksense -f qliksense3.yaml
```

