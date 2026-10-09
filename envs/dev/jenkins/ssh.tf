# resource "tls_private_key" "jenkins_master_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "jenkins_master_key" {
#   key_name   = "jenkins_master_key"
#   public_key = tls_private_key.jenkins_master_key.public_key_openssh
# }

resource "aws_key_pair" "jenkins_master_key" {
  key_name   = "jenkins_master_key"
  public_key = file("/home/finkord/dev/floci-gogs/keys/id_ed25519.pub")
}

# resource "tls_private_key" "jenkins_node_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "jenkins_node_key" {
#   key_name   = "jenkins_node_key"
#   public_key = tls_private_key.jenkins_node_key.public_key_openssh
# }

resource "aws_key_pair" "jenkins_node_key" {
  key_name   = "jenkins_node_key"
  public_key = file("/home/finkord/dev/floci-gogs/keys/id_ed25519.pub")
}
