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

    jenkinsAgent.vm.synced_folder "./configs/vm/", "/home/vagrant/key.pub/"
 
    jenkinsAgent.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update -y
    mkdir -p /home/vagrant/.ssh 
    chmod 700 /home/vagrant/.ssh 
    cat /home/vagrant/key.pub/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    chmod 600 /home/vagrant/.ssh/authorized_keys
    sudo chown -R vagrant:vagrant /home/vagrant/.ssh

    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update  -y

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    sudo usermod -aG docker vagrant

    sudo apt-get install fontconfig openjdk-21-jre -y

    sudo apt-get install build-essential -y
    SHELL
  end  
end
