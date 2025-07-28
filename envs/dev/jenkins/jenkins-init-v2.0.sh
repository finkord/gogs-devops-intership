#!/bin/bash
set -eux

DEVICE="/dev/xvdf"
MOUNT_POINT="/var/lib/jenkins"
FSTAB_ENTRY="$DEVICE $MOUNT_POINT ext4 defaults,nofail 0 2"

while [ ! -b "$DEVICE" ]; do
  echo "Waiting for $DEVICE to be ready..."
  sleep 2
done

if ! blkid $DEVICE; then
  echo "No filesystem found on $DEVICE, formatting..."
  mkfs.ext4 $DEVICE
fi

mkdir -p $MOUNT_POINT

if ! grep -qs "^$DEVICE " /etc/fstab; then
  echo "Adding $DEVICE to /etc/fstab..."
  echo "$FSTAB_ENTRY" >> /etc/fstab
  sudo systemctl daemon-reload
fi

mount $DEVICE $MOUNT_POINT

# allocate swap memory
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

##########################
#   Installing Jave      #
#   Installing Jenkins   #
##########################
sudo apt update -y
sudo apt install -y fontconfig openjdk-21-jre

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian/jenkins.io-2023.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y jenkins

chown -R jenkins:jenkins /var/lib/jenkins

sudo systemctl enable jenkins
sudo systemctl restart jenkins