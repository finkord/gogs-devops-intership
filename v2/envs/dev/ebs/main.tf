resource "aws_ebs_volume" "jenkins_ebs" {
  availability_zone = "us-east-1a"
  size              = 10
  type              = "gp3"

  tags = {
    Name = "jenkins-ebs"
  }
}
