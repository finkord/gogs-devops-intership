# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  # jenkinsAgent Server Configuration 192.168.128.20
  config.vm.define "jenkinsAgent" do |jenkinsAgent|
    # ==================================== #
    jenkinsAgent.vm.box = "ubuntu/jammy64"
  
    jenkinsAgent.vm.hostname = "jenkinsAgent"
    jenkinsAgent.vm.network "private_network", ip: "192.168.128.20"
  
    # VirtualBox provider settings for web VM
    jenkinsAgent.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
      vb.cpus = 4
    end
    # ==================================== #

    # jenkinsAgent.vm.synced_folder "./Keys/", "/home/vagrant/key.pub/"
 
    jenkinsAgent.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update -y
    # mkdir -p /home/vagrant/.ssh 
    # chmod 700 /home/vagrant/.ssh 
    # cat /home/vagrant/key.pub/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    # chmod 600 /home/vagrant/.ssh/authorized_keys
    # sudo chown -R vagrant:vagrant /home/vagrant/.ssh
    sudo apt-get install fontconfig openjdk-21-jre -y
    SHELL
  end  
end
