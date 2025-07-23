variable "region" { default = "us-east-1" }
variable "ami_id" { default = "ami-020cba7c55df1f615" }
variable "instance_type" { default = "t2.micro" }
variable "key_name" { default = "ecs2-keys-test" }
# variable "subnet_id" {
#   description = "Subnet ID to launch instance into"
#   type        = string
# }

locals {
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]
}

resource "aws_security_group" "jenkins_sg" {
  name        = "test-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "test-sg"
  }
}

resource "aws_instance" "test" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  key_name                    = var.key_name
  availability_zone           = "us-east-1a"
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    set -e
    
    exec > /var/log/user-data.log 2>&1

    export DEBIAN_FRONTEND=noninteractive

    apt update
    apt install -y openjdk-17-jdk

    wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian/jenkins.io-2023.key
    echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

    apt update
    apt install -y jenkins

    DEVICE_NAME="/dev/xvdf"
    FS_TYPE="ext4"

    # check device exists
    while [ ! -b "$DEVICE_NAME" ]; do
      echo "Waiting for device $DEVICE_NAME..."
      sleep 5
    done

    # check if already has filesystem
    if ! blkid "$DEVICE_NAME"; then
      mkfs -t "$FS_TYPE" "$DEVICE_NAME"
    fi

    mkdir -p /var/lib/jenkins
    echo "$DEVICE_NAME /var/lib/jenkins $FS_TYPE defaults,nofail 0 2" >> /etc/fstab
    mount -a

    chown -R jenkins:jenkins /var/lib/jenkins

    systemctl enable jenkins
    systemctl start jenkins
  EOF

  tags = {
    Name = "test-ec2"
  }
}

resource "aws_volume_attachment" "jenkins_attach" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.jenkins_ebs.id
  instance_id = aws_instance.test.id
}

# aws_key_pair.jenkins.key_name

# resource "aws_key_pair" "jenkins" {
#   key_name   = "jenkins-key"
#   public_key = file("U:/Dev/DevOps/terraform/keys/jenkins-key.pub")
# }
