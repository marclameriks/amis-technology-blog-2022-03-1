#!/bin/bash
echo "**** Begin installing Helm"

#Install socat
sudo apt-get install socat

#Install Helm
sudo snap install helm --classic

#Show version
helm version

# Wait 2 minutes
echo "**** Waiting 2 minutes ..."
sleep 120

#List pods
echo "**** List pods with namespace kube-system"
kubectl get pods --namespace kube-system

echo "**** End installing Helm"