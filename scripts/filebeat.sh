#!/bin/bash
echo "**** Begin installing Filebeat"

#Create ConfigMap before creating DaemonSet
kubectl create configmap filebeat-configmap --from-file=/vagrant/configmaps/configmap-filebeat --namespace nl-amis-logging

#Label ConfigMap
kubectl label configmap filebeat-configmap --namespace nl-amis-logging app=filebeat
kubectl label configmap filebeat-configmap --namespace nl-amis-logging version="1.0"
kubectl label configmap filebeat-configmap --namespace nl-amis-logging environment=logging

#List configmaps
echo "**** List configmap filebeat-configmap with namespace nl-amis-logging"
#kubectl describe configmaps filebeat-configmap --namespace nl-amis-logging
kubectl get configmaps filebeat-configmap --namespace nl-amis-logging -o yaml

#Create Helm chart
echo "**** Create Helm chart"
cd /vagrant
cd helmcharts
rm -rf /vagrant/helmcharts/filebeat-chart/*
helm create filebeat-chart

rm -rf /vagrant/helmcharts/filebeat-chart/templates/*
cp /vagrant/yaml/*filebeat.yaml /vagrant/helmcharts/filebeat-chart/templates

# Install Helm chart
cd /vagrant
cd helmcharts
echo "**** Install Helm chart filebeat-chart"
helm install filebeat-release ./filebeat-chart

# Wait 1 minute
echo "**** Waiting 1 minute ..."
sleep 60

echo "**** Check if a certain action (list) on a resource (pods) is allowed for a specific user (system:serviceaccount:nl-amis-logging:filebeat-serviceaccount) ****"
kubectl auth can-i list pods --as="system:serviceaccount:nl-amis-logging:filebeat-serviceaccount" --namespace nl-amis-logging

#List helm releases
echo "**** List helm releases"
helm list -d

#List pods
echo "**** List pods with namespace nl-amis-logging"
kubectl get pods --namespace nl-amis-logging

echo "**** End installing Filebeat"