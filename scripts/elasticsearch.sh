#!/bin/bash
echo "**** Begin installing Elasticsearch"

#Create Helm chart
echo "**** Create Helm chart"
cd /vagrant
cd helmcharts
rm -rf /vagrant/helmcharts/elasticsearch-chart/*
helm create elasticsearch-chart

rm -rf /vagrant/helmcharts/elasticsearch-chart/templates/*
cp /vagrant/yaml/*elasticsearch.yaml /vagrant/helmcharts/elasticsearch-chart/templates

# Install Helm chart
cd /vagrant
cd helmcharts
echo "**** Install Helm chart elasticsearch-chart"
helm install elasticsearch-release ./elasticsearch-chart

# Wait 2,5 minute
echo "**** Waiting 2,5 minute ..."
sleep 150

#List helm releases
echo "**** List helm releases"
helm list -d

#List pods
echo "**** List pods with namespace nl-amis-logging"
kubectl get pods --namespace nl-amis-logging

#List services
echo "**** List services with namespace nl-amis-logging"
kubectl get service --namespace nl-amis-logging

echo "**** Determine the IP of the minikube node"
nodeIP=$(kubectl get node minikube -o yaml | grep address: | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
echo "---$nodeIP---"

echo "**** Via socat forward local port 9200 to port 30200 on the minikube node ($nodeIP)"
socat tcp-listen:9200,fork tcp:$nodeIP:30200 &

echo "**** Send a request to Elasticsearch"
curl -XGET http://localhost:9200/_count?pretty

#http://localhost:9200/_count?pretty

echo "**** End installing Elasticsearch"