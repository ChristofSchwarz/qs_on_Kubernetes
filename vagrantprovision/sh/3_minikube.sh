echo 'executing "3_minikube.sh"'

sudo swapoff -a

echo 'Installing Kubernetes'

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update -y -qq
apt-get install -y kubectl kubeadm kubelet 

sudo curl -s -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && sudo chmod +x minikube && sudo mv minikube /usr/local/bin/
 
#https://github.com/kubernetes/minikube
echo 'Setting Developer Mode'
export MINIKUBE_WANTUPDATENOTIFICATION=false
export MINIKUBE_WANTREPORTERRORPROMPT=false
export MINIKUBE_HOME=/home/vagrant
export CHANGE_MINIKUBE_NONE_USER=true
export KUBECONFIG=/home/vagrant/.kube/config

#we want things things to stick each time we login or start the machine
echo "export MINIKUBE_WANTUPDATENOTIFICATION=false" >> /home/vagrant/.bash_profile
echo "export MINIKUBE_WANTREPORTERRORPROMPT=false" >> /home/vagrant/.bash_profile
echo "export MINIKUBE_HOME=/home/vagrant" >> /home/vagrant/.bash_profile
echo "export CHANGE_MINIKUBE_NONE_USER=true" >> /home/vagrant/.bash_profile
echo "export KUBECONFIG=/home/vagrant/.kube/config" >> /home/vagrant/.bash_profile
echo "sudo swapoff -a" >> /home/vagrant/.bash_profile
echo "source <(kubectl completion bash)" >> /home/vagrant/.bash_profile
echo "sudo chown -R vagrant /home/vagrant/.kube" >> /home/vagrant/.bash_profile
echo "sudo chgrp -R vagrant /home/vagrant/.kube" >> /home/vagrant/.bash_profile

#sudo cp /root/.minikube $HOME/.minikube
echo "sudo chown -R vagrant /home/vagrant/.minikube" >> /home/vagrant/.bash_profile
echo "sudo chgrp -R vagrant /home/vagrant/.minikube" >> /home/vagrant/.bash_profile

mkdir /home/vagrant/.kube || true
touch /home/vagrant/.kube/config

echo 'Starting minikube local cluster'

minikube start --memory 4096 --cpus=2 --vm-driver=none

#sudo cp /root/.kube $HOME/.kube
sudo chown -R vagrant /home/vagrant/.kube
sudo chgrp -R vagrant /home/vagrant/.kube

#sudo cp /root/.minikube $HOME/.minikube
sudo chown -R vagrant /home/vagrant/.minikube
sudo chgrp -R vagrant /home/vagrant/.minikube

echo 'Getting Helm'
curl -s https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

helm init --wait --upgrade
