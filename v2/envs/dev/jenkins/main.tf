variable "region" { default = "us-east-1" }
variable "ami_id" { default = "ami-020cba7c55df1f615" }
variable "instance_type" { default = "t2.micro" }
variable "key_name" { default = "jenkins-key" }

locals {
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]
}

resource "aws_key_pair" "jenkins" {
  key_name   = "jenkins-key"
  public_key = file("U:/Dev/DevOps/terraform/keys/jenkins-key.pub")
}

locals {
  user_data = file("./jenkins-v1.0.sh")
}

resource "aws_instance" "jenkins-master" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [data.terraform_remote_state.sg.outputs.jenkins_sg_id]
  key_name                    = var.key_name
  availability_zone           = "us-east-1a"
  associate_public_ip_address = true
  user_data                   = local.user_data

  tags = {
    Name = "jenkins-master-ec2"
  }
}

resource "aws_volume_attachment" "jenkins_attach_ebs" {
  device_name  = "/dev/xvdf"
  volume_id    = data.terraform_remote_state.ebs.outputs.ebs_id
  instance_id  = aws_instance.jenkins-master.id
  force_detach = true
}
