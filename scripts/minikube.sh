#!/bin/bash
echo "**** Begin downloading minikube"

#Kubernetes 1.22.3 requires conntrack to be installed in root's path
sudo apt install -y conntrack

#Download a static binary
curl -o minikube https://storage.googleapis.com/minikube/releases/v1.24.0/minikube-linux-amd64
chmod +x minikube

#Add the Minikube executable to your path
sudo cp minikube /usr/local/bin/ 
rm minikube

echo "**** End downloading minikube"

echo "**** Begin starting a Cluster"

sudo sysctl fs.protected_regular=0

#Start a Cluster
minikube start \
  --vm-driver=none \
  --extra-config=kubeadm.node-name=minikube \
  --extra-config=kubelet.hostname-override=minikube

#To use kubectl or minikube commands as your own user, you may need to relocate them.
sudo cp -R /root/.kube /root/.minikube /home/vagrant
sudo chown -R vagrant /home/vagrant/.kube /home/vagrant/.minikube

sed -i 's/root/home\/vagrant/g' /home/vagrant/.kube/config

echo "**** End starting a Cluster"

echo "**** Begin preparing dashboard"
minikube dashboard --url </dev/null &>/dev/null &
echo "**** End preparing dashboard"

minikube kubectl -- get pods -A
