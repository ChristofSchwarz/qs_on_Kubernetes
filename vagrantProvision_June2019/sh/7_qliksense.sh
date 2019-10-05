
echo 'executing 7_qliksense.sh ...'

echo 'Adding stable and edge reop from qlik.bintray.com'
helm repo add qlik-stable https://qlik.bintray.com/stable
helm repo add qlik-edge https://qlik.bintray.com/edge
helm init
helm repo update

echo 'installing stable "qliksense-init"'
helm install -n qlikinit qlik-stable/qliksense-init

echo 'installing stable "qliksense"'
helm install -n qlik qlik-stable/qliksense -f /vagrant/yaml/qliksense.yaml 
