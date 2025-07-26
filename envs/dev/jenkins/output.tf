output "instance_id" {
  value = aws_instance.jenkins-master.id
}

output "jenkins_master_public_ip" {
  value = aws_instance.jenkins-master.public_ip
}
