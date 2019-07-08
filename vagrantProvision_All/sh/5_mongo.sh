echo 'execute "5_mongo.sh"'

echo 'Creating PVC for MongoDB'
kubectl apply -f /vagrant/files/pvc_mongo.yaml

echo 'Installing MongoDB chart'
helm install -n mongo stable/mongodb -f /vagrant/files/mongo.yaml 
