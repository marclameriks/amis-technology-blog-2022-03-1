#!/bin/bash
echo "**** Begin installing Kibana"

#Create Helm chart
echo "**** Create Helm chart"
cd /vagrant
cd helmcharts
rm -rf /vagrant/helmcharts/kibana-chart/*
helm create kibana-chart

rm -rf /vagrant/helmcharts/kibana-chart/templates/*
cp /vagrant/yaml/*kibana.yaml /vagrant/helmcharts/kibana-chart/templates

# Install Helm chart
cd /vagrant
cd helmcharts
echo "**** Install Helm chart kibana-chart"
helm install kibana-release ./kibana-chart

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

echo "**** Via socat forward local port 5601 to port 30601 on the minikube node ($nodeIP)"
socat tcp-listen:5601,fork tcp:$nodeIP:30601 &

#http://localhost:5601/app/kibana

echo "**** End installing Kibana"