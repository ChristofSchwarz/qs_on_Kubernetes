echo 'executing 4_helm.sh ...'
curl -s https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
# changed on 21-05-2019: helm version 2.14 doesn't work, getting an older version
./get_helm.sh --version v2.13.1

#Initialize Helm Tiller pod, upgrade and update the repos
helm init
helm init --wait --upgrade
helm repo update

