#create PVC for MongoDB
kubectl apply -f /vagrant/files/pvc_mongo.yaml

#Install MongoDB
helm install -n mongo stable/mongodb -f /vagrant/files/mongo.yaml 
