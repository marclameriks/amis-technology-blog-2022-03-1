#!/bin/bash
echo "**** Begin installing namespaces"

#Create Helm chart
echo "**** Create Helm chart"
cd /vagrant
cd helmcharts
rm -rf /vagrant/helmcharts/namespace-chart/*
helm create namespace-chart

rm -rf /vagrant/helmcharts/namespace-chart/templates/*
cp /vagrant/yaml/namespace*.yaml /vagrant/helmcharts/namespace-chart/templates

# Install Helm chart
cd /vagrant
cd helmcharts
echo "**** Install Helm chart namespace-chart"
helm install namespace-release ./namespace-chart

# Wait 30 seconds
echo "**** Waiting 30 seconds ..."
sleep 30

#List helm releases
echo "**** List helm releases"
helm list -d

#List namespaces
echo "**** List namespaces"
kubectl get namespaces

echo "**** End installing namespaces"