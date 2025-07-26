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
  security_groups = [data.terraform_remote_state.sg.outputs.efs_sg_id]
}
