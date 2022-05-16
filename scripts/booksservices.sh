#!/bin/bash
echo "**** Begin installing booksservices"

#Create Helm chart
echo "**** Create Helm chart"
cd /vagrant
cd helmcharts
rm -rf /vagrant/helmcharts/booksservice-chart/*
helm create booksservice-chart

rm -rf /vagrant/helmcharts/booksservice-chart/templates/*
cp /vagrant/yaml/*booksservice*.yaml /vagrant/helmcharts/booksservice-chart/templates

# Create Docker images
echo "**** Docker images"
cd /vagrant
cd applications
cd books_service_1.0
docker build -t booksservice:v1.0 .

cd ..
cd books_service_2.0
docker build -t booksservice:v2.0 .

# Wait 30 seconds
echo "**** Waiting 30 seconds ..."
sleep 30

# Install Helm chart
cd /vagrant
cd helmcharts
echo "**** Install Helm chart booksservice-chart"
helm install booksservice-release ./booksservice-chart

# Wait 2,5 minute
echo "**** Waiting 2,5 minute ..."
sleep 150

#List helm releases
echo "**** List helm releases"
helm list -d

#List pods
echo "**** List pods with namespace nl-amis-testing"
kubectl get pods --namespace nl-amis-testing

#List services
echo "**** List services with namespace nl-amis-testing"
kubectl get service --namespace nl-amis-testing

echo "**** Determine the IP of the minikube node"
nodeIP=$(kubectl get node minikube -o yaml | grep address: | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
echo "---$nodeIP---"

echo "**** Via socat forward local port 9010 to port 30010 on the minikube node ($nodeIP)"
socat tcp-listen:9010,fork tcp:$nodeIP:30010 &

echo "**** Via socat forward local port 9020 to port 30020 on the minikube node ($nodeIP)"
socat tcp-listen:9020,fork tcp:$nodeIP:30020 &

echo "**** Via socat forward local port 9110 to port 30110 on the minikube node ($nodeIP)"
socat tcp-listen:9110,fork tcp:$nodeIP:30110 &

echo "**** Add books"
curl --header "Content-Type: application/json" --request POST --data '{"id": 1, "title": "The Threat: How the FBI Protects America in the Age of Terror and Trump", "author": "Andrew G. McCabe", "type": "Hardcover", "price": 17.99, "numOfPages": 288, "language": "English", "isbn13": "978-1250207579"}' http://localhost:9110/books

curl --header "Content-Type: application/json" --request POST --data '{"id": 2, "title": "Becoming", "publishDate": "2018-11-13", "author": "Michelle Obama", "type": "Hardcover", "price": 17.88, "numOfPages": 448, "publisher": "Crown Publishing Group; First Edition edition", "language": "English", "isbn13": "978-1524763138"}' http://localhost:9110/books

echo "**** Get books"
curl http://localhost:9110/books

echo ""
echo "**** List the books in the database"
mysql -h 127.0.0.1 -uroot -ppassword -e "show databases;"
mysql -h 127.0.0.1 -uroot -ppassword -e "use test; select * from book;"

echo "**** End installing booksservices"