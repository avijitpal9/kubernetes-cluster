# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.


Vagrant.configure("2") do |config|

  config.vm.box = "centos/7"
  config.vm.box_check_update = false

  config.vm.define "master1" do |master1|
     master1.vm.hostname="master1.internal"
	 master1.vm.network :private_network, ip: "192.168.195.10"
	 master1.vm.synced_folder "D:\\Git", "/opt/git", create: true
	 master1.vm.provider :virtualbox do |ps|
	   ps.memory=3072
           ps.cpus = 2
	 end
	 master1.vm.provision "shell", path: "k8s-bootstrap.sh"
  end

  config.vm.define "node1" do |node1|
     node1.vm.hostname="node1.internal"
	 node1.vm.network :private_network, ip: "192.168.195.20"
	 node1.vm.provider :virtualbox do |ps|
	   ps.memory=2048
	   ps.cpus = 2
	 end
	 node1.vm.provision "shell", path: "k8s-bootstrap.sh"
  end


  config.vm.define "node2" do |node2|
     node2.vm.hostname="node2.internal"
	 node2.vm.network :private_network, ip: "192.168.195.30"
	 node2.vm.provider :virtualbox do |ps|
	   ps.memory=2048
	   ps.cpus = 2
	 end
	 node2.vm.provision "shell", path: "k8s-bootstrap.sh"
  end

end
