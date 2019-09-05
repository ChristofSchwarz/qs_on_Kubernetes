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
 * kubectl.exe should now be available in C:\Kubernetes. You may want add C:\Kubernetes to the „PATH“ variable of Windows, so that you can type the kubectl command from within other folder in Powershell or Cmd.

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
Create a storage-class from this <a href="https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/AKS/storageclass.yaml" yaml-file> using this command
```
kubectl apply -f https://raw.githubusercontent.com/ChristofSchwarz/qs_on_Kubernetes/master/AKS/storageclass.yaml
```
(Alternatively, you can also download the file and use it in the -f parameter locally)

## Installing and configuring helm
  

## yaml-Settings for QSEoK on Azure Kubernetes Services (AKS)

Different settings files for your scenario. Apply with the following command
```
helm upgrade [RELEASE] [REPO]/qliksense -f qliksense.yaml
helm upgrade qliksense qlik-stable/qliksense -f qliksense.yaml
```
### qliksense.yaml
 * just a starting-point, will not work since no identity provider is specified
### qliksense2.yaml
 * built-in MongoDB (test only)
 * built-in OIDC listening to https://elastic.example (users need to set their hosts. file to login to QSEoK)
### qliksense3.yaml
 * built-in MongoDB (test only)
 * using Auth0 as IDP (identity provider) 
