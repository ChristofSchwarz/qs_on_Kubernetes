echo 'execute "5_mongo.sh"'

echo 'Creating PVC for MongoDB'
kubectl apply -f /vagrant/yaml/pvc_mongo.yaml

echo 'Installing MongoDB chart'
helm init
helm repo update
helm install -n mongo stable/mongodb -f /vagrant/yaml/mongo.yaml 
