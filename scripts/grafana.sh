#!/bin/bash
echo "**** Begin installing Grafana"

#Create Helm chart
echo "**** Create Helm chart"
cd /vagrant
cd helmcharts
rm -rf /vagrant/helmcharts/grafana-chart/*
helm create grafana-chart

rm -rf /vagrant/helmcharts/grafana-chart/templates/*
cp /vagrant/yaml/*grafana.yaml /vagrant/helmcharts/grafana-chart/templates

# Install Helm chart
cd /vagrant
cd helmcharts
echo "**** Install Helm chart grafana-chart"
helm install grafana-release ./grafana-chart

# Wait 2,5 minute
echo "**** Waiting 2,5 minute ..."
sleep 150

#List helm releases
echo "**** List helm releases"
helm list -d

#List pods
echo "**** List pods with namespace nl-amis-visualization"
kubectl get pods --namespace nl-amis-visualization

#List services
echo "**** List services with namespace nl-amis-visualization"
kubectl get service --namespace nl-amis-visualization

echo "**** Determine the IP of the minikube node"
nodeIP=$(kubectl get node minikube -o yaml | grep address: | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
echo "---$nodeIP---"

echo "**** Via socat forward local port 3000 to port 30300 on the minikube node ($nodeIP)"
socat tcp-listen:3000,fork tcp:$nodeIP:30300 &

echo "**** End installing Grafana"