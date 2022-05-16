#!/bin/bash
echo "**** Begin installing MySQL"

#Install mysql-client
sudo apt-get install -y mysql-client

#Create Helm chart
echo "**** Create Helm chart"
cd /vagrant
cd helmcharts
rm -rf /vagrant/helmcharts/mysql-chart/*
helm create mysql-chart

rm -rf /vagrant/helmcharts/mysql-chart/templates/*
cp /vagrant/yaml/*mysql.yaml /vagrant/helmcharts/mysql-chart/templates

# Install Helm chart
cd /vagrant
cd helmcharts
echo "**** Install Helm chart mysql-chart"
helm install mysql-release ./mysql-chart

# Wait 1 minute
echo "**** Waiting 1 minute ..."
sleep 60

#List helm releases
echo "**** List helm releases"
helm list -d

#List pods
echo "**** List pods with namespace nl-amis-testing"
kubectl get pods --namespace nl-amis-testing

#List services
echo "**** List services with namespace nl-amis-testing"
kubectl get service --namespace nl-amis-testing

echo "**** Begin preparing mysql database 'test'"

echo "**** Forward local port 3306 to port 3306 on the mysql-service service"
kubectl port-forward service/mysql-service 3306 --namespace nl-amis-testing </dev/null &>/dev/null &

# Wait 2,5 minute
echo "**** Waiting 2,5 minute ..."
sleep 150

mysql -h 127.0.0.1 -uroot -ppassword -e "create database if not exists test"
mysql -h 127.0.0.1 -uroot -ppassword -e "show databases;"

echo "**** Creating table book"
mysql -h 127.0.0.1 -uroot -ppassword -e "use test; CREATE TABLE book (
  id varchar(255) NOT NULL,
  author varchar(255) DEFAULT NULL,
  isbn13 varchar(255) DEFAULT NULL,
  language varchar(255) DEFAULT NULL,
  num_of_pages int(11) NOT NULL,
  price double NOT NULL,
  title varchar(255) DEFAULT NULL,
  type varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
);"
mysql -h 127.0.0.1 -uroot -ppassword -e "use test; desc book;"
echo "**** End preparing mysql database 'test'"

echo "**** End installing MySQL"
