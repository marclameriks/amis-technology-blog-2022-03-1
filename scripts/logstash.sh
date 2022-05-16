#!/bin/bash
echo "**** Begin installing Logstash"

#Create ConfigMap before creating Deployment
kubectl create configmap logstash-configmap --from-file=/vagrant/configmaps/configmap-logstash --namespace nl-amis-logging

#Label ConfigMap
kubectl label configmap logstash-configmap --namespace nl-amis-logging app=logstash
kubectl label configmap logstash-configmap --namespace nl-amis-logging version="1.0"
kubectl label configmap logstash-configmap --namespace nl-amis-logging environment=logging

#List configmaps
echo "**** List configmap logstash-configmap with namespace nl-amis-logging"
#kubectl describe configmaps logstash-configmap --namespace nl-amis-logging
kubectl get configmaps logstash-configmap --namespace nl-amis-logging -o yaml

#Create Helm chart
echo "**** Create Helm chart"
cd /vagrant
cd helmcharts
rm -rf /vagrant/helmcharts/logstash-chart/*
helm create logstash-chart

rm -rf /vagrant/helmcharts/logstash-chart/templates/*
cp /vagrant/yaml/*logstash.yaml /vagrant/helmcharts/logstash-chart/templates

# Install Helm chart
cd /vagrant
cd helmcharts
echo "**** Install Helm chart logstash-chart"
helm install logstash-release ./logstash-chart

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

echo "**** End installing Logstash"
