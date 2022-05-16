Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  
  config.vm.define "ubuntu_minikube_helm_elastic" do |ubuntu_minikube_helm_elastic|
  
    config.vm.network "forwarded_port",
      guest: 3000,
      host:  3000,
      auto_correct: true
      
    config.vm.network "forwarded_port",
      guest: 8001,
      host:  8001,
      auto_correct: true
      
    config.vm.network "forwarded_port",
      guest: 5601,
      host:  5601,
      auto_correct: true
      
    config.vm.network "forwarded_port",
      guest: 9200,
      host:  9200,
      auto_correct: true
      
    config.vm.network "forwarded_port",
      guest: 9010,
      host:  9010,
      auto_correct: true
      
    config.vm.network "forwarded_port",
      guest: 9020,
      host:  9020,
      auto_correct: true
      
    config.vm.network "forwarded_port",
      guest: 9110,
      host:  9110,
      auto_correct: true
      
    config.vm.provider "virtualbox" do |vb|
        vb.name = "Ubuntu Minikube Helm Elastic Stack"
        vb.memory = "8192"
        vb.cpus = "2"
        
    args = []
    config.vm.provision "docker shell script", type: "shell",
        path: "scripts/docker.sh",
        args: args
        
    args = []
    config.vm.provision "minikube shell script", type: "shell",
        path: "scripts/minikube.sh",
        args: args
        
    args = []
    config.vm.provision "kubectl shell script", type: "shell",
        path: "scripts/kubectl.sh",
        args: args
        
            args = []
    config.vm.provision "helm shell script", type: "shell",
        path: "scripts/helm.sh",
        args: args
        
    args = []
    config.vm.provision "namespaces shell script", type: "shell",
        path: "scripts/namespaces.sh",
        args: args
        
    args = []
    config.vm.provision "elasticsearch shell script", type: "shell",
        path: "scripts/elasticsearch.sh",
        args: args
        
    args = []
    config.vm.provision "kibana shell script", type: "shell",
        path: "scripts/kibana.sh",
        args: args
        
    args = []
    config.vm.provision "logstash shell script", type: "shell",
        path: "scripts/logstash.sh",
        args: args
        
    args = []
    config.vm.provision "filebeat shell script", type: "shell",
        path: "scripts/filebeat.sh",
        args: args
        
    args = []
    config.vm.provision "mysql shell script", type: "shell",
        path: "scripts/mysql.sh",
        args: args
        
    args = []
    config.vm.provision "booksservices shell script", type: "shell",
        path: "scripts/booksservices.sh",
        args: args
        
    args = []
    config.vm.provision "grafana shell script", type: "shell",
        path: "scripts/grafana.sh",
        args: args
    end
    
  end

end
