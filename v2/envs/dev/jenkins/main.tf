# EC2 instance with EFS mount via user_data
resource "aws_instance" "jenkins" {
  ami                         = "ami-020cba7c55df1f615"
  instance_type               = "t2.micro"
  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]
  vpc_security_group_ids      = ["sg-082242e6dd08a297b"] #[data.terraform_remote_state.sg.outputs.rds_sg_id]
  associate_public_ip_address = true
  key_name                    = "ecs2-keys-test" # Replace with existing key

  # iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  # user_data = <<-EOF
  #             #!/bin/bash
  #             yum install -y amazon-efs-utils
  #             mkdir -p /mnt/efs
  #             echo "${aws_efs_file_system.efs.id}:/ /mnt/efs efs _netdev,tls 0 0" >> /etc/fstab
  #             mount -a
  #             EOF

  tags = {
    Name = "ec2-with-jenkins"
  }

  lifecycle {
    prevent_destroy = false
  }
}
