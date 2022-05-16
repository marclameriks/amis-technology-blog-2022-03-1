#!/bin/bash
echo "**** Begin installing kubectl"

#Install kubectl binary 
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

#Check the kubectl configuration
kubectl cluster-info

echo "**** End installing kubectl"

echo "**** Begin preparing dashboard"

kubectl proxy --address='0.0.0.0' </dev/null &>/dev/null &

echo "**** End preparing dashboard"