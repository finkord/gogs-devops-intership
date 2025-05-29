# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  # Ansible Server Configuration 192.168.128.20
  config.vm.define "ansible" do |ansible|
    # ==================================== #
    ansible.vm.box = "ubuntu/jammy64"

    ansible.vm.hostname = "ansible"
    ansible.vm.network "private_network", ip: "192.168.128.20"

    # VirtualBox provider settings
    ansible.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
    end
    # ==================================== #

    ansible.vm.synced_folder "./Ansible/", "/home/vagrant/ansible/"

    ansible.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update -y
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt-get install -y ansible
    SHELL
  end  
  # PostgresSQL Server Configuration 192.168.128.29
  config.vm.define "psql" do |psql|
    # ==================================== #
    psql.vm.box = "ubuntu/jammy64"
  
    psql.vm.hostname = "psql"
    psql.vm.network "private_network", ip: "192.168.128.29"
  
    # VirtualBox provider settings for web VM
    psql.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
    end
    # ==================================== #

    psql.vm.synced_folder "./Keys/", "/home/vagrant/key.pub/"
 
    psql.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update -y
    mkdir -p /home/vagrant/.ssh 
    chmod 700 /home/vagrant/.ssh 
    cat /home/vagrant/key.pub/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    chmod 600 /home/vagrant/.ssh/authorized_keys
    sudo chown -R vagrant:vagrant /home/vagrant/.ssh
    SHELL
  end 
  # Splunk Server Configuration 192.168.128.21
  config.vm.define "splunk" do |splunk|
    # ==================================== #
    splunk.vm.box = "ubuntu/jammy64"
  
    splunk.vm.hostname = "splunk"
    splunk.vm.network "private_network", ip: "192.168.128.21"
  
    # VirtualBox provider settings for web VM
    splunk.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
      vb.cpus = 4
    end
    # ==================================== #

    splunk.vm.synced_folder "./Keys/", "/home/vagrant/key.pub/"
    splunk.vm.synced_folder "./Splunk/", "/home/vagrant/splunk/"
 
    splunk.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update -y
    mkdir -p /home/vagrant/.ssh 
    chmod 700 /home/vagrant/.ssh 
    cat /home/vagrant/key.pub/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    chmod 600 /home/vagrant/.ssh/authorized_keys
    sudo chown -R vagrant:vagrant /home/vagrant/.ssh
    SHELL
  end 
  # NFS Server Configuration 192.168.128.28
  config.vm.define "nfs" do |nfs|
    # ==================================== #
    nfs.vm.box = "ubuntu/jammy64"
  
    nfs.vm.hostname = "nfs"
    nfs.vm.network "private_network", ip: "192.168.128.28"
  
    # VirtualBox provider settings for web VM
    nfs.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
    end
    # ==================================== #

    nfs.vm.synced_folder "./Keys/", "/home/vagrant/key.pub/"
    nfs.vm.synced_folder "./NFS/", "/home/vagrant/nfs/"
 
    nfs.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update -y
    mkdir -p /home/vagrant/.ssh 
    chmod 700 /home/vagrant/.ssh 
    cat /home/vagrant/key.pub/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    chmod 600 /home/vagrant/.ssh/authorized_keys
    sudo chown -R vagrant:vagrant /home/vagrant/.ssh

    sudo apt-get install nfs-kernel-server -y
    sudo mkdir -p /srv/gogs-repositories
    sudo chown git:git /srv/gogs-repositories
    echo "/srv/gogs-repositories *(rw,sync,no_subtree_check)" >> /etc/exports
    sudo exportfs -ra
    SHELL
  end 
  # Jenkins Server Configuration 192.168.128.22
  config.vm.define "jenkins" do |jenkins|
    # ==================================== #
    jenkins.vm.box = "ubuntu/jammy64"
  
    jenkins.vm.hostname = "jenkins"
    jenkins.vm.network "private_network", ip: "192.168.128.22"
  
    # VirtualBox provider settings for web VM
    jenkins.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 1
    end
    # ==================================== #

    jenkins.vm.synced_folder "./Keys/", "/home/vagrant/key.pub/"
    jenkins.vm.synced_folder "./Jenkins/", "/home/vagrant/jenkins/"

    jenkins.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update -y
    mkdir -p /home/vagrant/.ssh 
    chmod 700 /home/vagrant/.ssh 
    cat /home/vagrant/key.pub/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    chmod 600 /home/vagrant/.ssh/authorized_keys
    sudo chown -R vagrant:vagrant /home/vagrant/.ssh

    sudo apt-get install fontconfig openjdk-21-jre -y

    sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

    echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

    sudo apt-get update -y
    sudo apt-get install jenkins -y
    SHELL
  end 
  # jenkins_node Server Configuration 192.168.128.23
  config.vm.define "nodeJenkins" do |nodeJenkins|
    # ==================================== #
    nodeJenkins.vm.box = "ubuntu/jammy64"
  
    nodeJenkins.vm.hostname = "nodeJenkins"
    nodeJenkins.vm.network "private_network", ip: "192.168.128.23"
  
    # VirtualBox provider settings for web VM
    nodeJenkins.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
      vb.cpus = 4
    end
    # ==================================== #

    nodeJenkins.vm.synced_folder "./Keys/", "/home/vagrant/key.pub/"
 
    nodeJenkins.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update -y
    mkdir -p /home/vagrant/.ssh 
    chmod 700 /home/vagrant/.ssh 
    cat /home/vagrant/key.pub/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    chmod 600 /home/vagrant/.ssh/authorized_keys
    sudo chown -R vagrant:vagrant /home/vagrant/.ssh

    sudo apt-get install fontconfig openjdk-21-jre -y
    SHELL
  end 
  # Nginx Server Configuration 192.168.128.30
  config.vm.define "nginx" do |nginx|
    # ==================================== #
    nginx.vm.box = "ubuntu/jammy64"
  
    nginx.vm.hostname = "nginx"
    nginx.vm.network "private_network", ip: "192.168.128.30"
  
    # VirtualBox provider settings for web VM
    nginx.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
    end
    # ==================================== #

    nginx.vm.synced_folder "./Keys/", "/home/vagrant/key.pub/"

    nginx.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update -y
    mkdir -p /home/vagrant/.ssh 
    chmod 700 /home/vagrant/.ssh 
    cat /home/vagrant/key.pub/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    chmod 600 /home/vagrant/.ssh/authorized_keys
    sudo chown -R vagrant:vagrant /home/vagrant/.ssh
    SHELL
  end 
  # Gogs Servers Configuration 192.168.128.31:3001 && 192.168.128.32:3002
  (1..2).each do |i|
    config.vm.define "gogs#{i}" do |node|
      # ==================================== #
      node.vm.box = "ubuntu/jammy64"

      node.vm.hostname = "gogs#{i}"
      node.vm.network "private_network", ip: "192.168.128.#{31 + i}"
      node.vm.network "forwarded_port", guest: 3000, host: 3000 + i

      node.vm.provider "virtualbox" do |vb|
        vb.memory = 512
        vb.cpus = 1
      end
      # ==================================== #

      node.vm.synced_folder "./Keys/", "/home/vagrant/key.pub/"

      node.vm.provision "shell", inline: <<-SHELL
        # sudo apt-get update -y
        mkdir -p /home/vagrant/.ssh 
        chmod 700 /home/vagrant/.ssh 
        cat /home/vagrant/key.pub/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
        chmod 600 /home/vagrant/.ssh/authorized_keys
        sudo chown -R vagrant:vagrant /home/vagrant/.ssh
      SHELL
    end
  end   
end
