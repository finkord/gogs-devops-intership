
resource "aws_security_group" "efs_sg" {
  name        = "gogs-efs-sg"
  description = "Allow NFS access from ECS"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.ecs.outputs.security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gogs-efs-sg"
  }
}


resource "aws_efs_file_system" "gogs_efs" {
  creation_token = "gogs-efs"
  encrypted      = true
  tags = {
    Name = "gogs-efs"
  }
}

resource "aws_efs_mount_target" "gogs_efs_mount" {
  for_each        = toset(data.terraform_remote_state.vpc.outputs.private_subnet_ids)
  file_system_id  = aws_efs_file_system.gogs_efs.id
  subnet_id       = each.key
  security_groups = [aws_security_group.efs_sg.id]
}
