#!/bin/bash
echo "**** Begin installing Docker Engine"

#Uninstall old versions
sudo apt-get remove docker docker-engine docker.io containerd runc

#Set up the repository
##Update the apt package index
sudo apt-get update
##Install packages to allow apt to use a repository over HTTPS
sudo apt-get install ca-certificates
sudo apt-get install curl
sudo apt-get install gnupg
sudo apt-get install lsb-release

##Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
##Set up the stable repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Install Docker Engine
##Update the apt package index
sudo apt-get update -qq
#Install a specific version of Docker Engine 
sudo apt-get install -yqq docker-ce=5:20.10.10~3-0~ubuntu-focal docker-ce-cli=5:20.10.10~3-0~ubuntu-focal containerd.io
#Verify that Docker Engine is installed correctly by running the hello-world image
sudo docker run hello-world
#use Docker as a non-root user
sudo usermod -aG docker vagrant

echo "**** End installing Docker Engine"