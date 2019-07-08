
#Install qliksense from stable repo
helm repo add qlik-stable https://qlik.bintray.com/stable
helm repo add qlik-edge https://qlik.bintray.com/edge

# install the initial settings
helm install -n qlikinit qlik-stable/qliksense-init

# install qlik sense enterprise on kubernetes
helm install -n qlik qlik-stable/qliksense -f /vagrant/files/qliksense.yaml 
