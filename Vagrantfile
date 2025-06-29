# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  # -------------------------------
  # Jenkins Agent Configuration
  # Static IP: 192.168.128.20
  # -------------------------------
  config.vm.define "jenkinsAgent" do |jenkinsAgent|
    # Base VM image
    jenkinsAgent.vm.box = "ubuntu/jammy64"
    jenkinsAgent.vm.hostname = "jenkinsAgent"

    # Static IP for local private network
    jenkinsAgent.vm.network "private_network", ip: "192.168.128.20"

    # VirtualBox Provider Configuration
    jenkinsAgent.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 4
    end

    # jenkinsAgent.vm.synced_folder "./configs/vm/", "/home/vagrant/key.pub/"
    
    # Provision: Copy public SSH key to guest
    jenkinsAgent.vm.provision "file",
      source: "./configs/vm/id_rsa.pub",
      destination: "/home/vagrant/key.pub/id_rsa.pub"

    # Provision: Install Docker, Java, and essential packages
    jenkinsAgent.vm.provision "shell", inline: <<-SHELL
      set -eux

      # SSH key setup
      install -d -m 0700 /home/vagrant/.ssh
      cat /home/vagrant/key.pub/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
      chmod 600 /home/vagrant/.ssh/authorized_keys
      sudo chown -R vagrant:vagrant /home/vagrant/.ssh

      # Add Docker GPG key and repo
      sudo install -m 0755 -d /etc/apt/keyrings
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc

      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

      # System update and package installation
      apt-get update -y
      apt-get install -y \
        docker-ce docker-ce-cli containerd.io \
        docker-buildx-plugin docker-compose-plugin \
        fontconfig openjdk-21-jre \
        build-essential

      # Add vagrant user to docker group
      sudo usermod -aG docker vagrant

      # Display IP configuration
      echo "========== IP ADDRESS =========="
      ip -4 addr show | awk '/inet / && $NF != "lo" { print "Interface:", $NF, "IP:", $2 }'
      echo "==============================="
      SHELL
  end  
end
