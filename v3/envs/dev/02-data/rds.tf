resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "rds" {
  source = "../../../modules/rds"

  project            = "gogs"
  db_name            = "gogs"
  username           = "gogs"
  password           = random_password.rds_password.result
  subnet_ids         = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  security_group_ids = [data.terraform_remote_state.sg.outputs.rds_sg_id]
}

variable "project" {
  type        = string
  description = "Project name used in parameter names"
  default     = module.rds.project
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/rds/${var.project}/db_password"
  type        = "SecureString"
  value       = random_password.rds_password.result
  description = "RDS database password for project ${var.project}"
}

resource "aws_ssm_parameter" "db_username" {
  name        = "/rds/${var.project}/db_username"
  type        = "String"
  value       = module.rds.db_username
  description = "RDS database username"
}

resource "aws_ssm_parameter" "db_name" {
  name        = "/rds/${var.project}/db_name"
  type        = "String"
  value       = module.rds.db_name
  description = "RDS database name"
}

resource "aws_ssm_parameter" "db_host" {
  name        = "/rds/${var.project}/db_host"
  type        = "String"
  value       = module.rds.db_host
  description = "RDS database endpoint"
}

resource "aws_ssm_parameter" "db_port" {
  name        = "/rds/${var.project}/db_port"
  type        = "String"
  value       = tostring(module.rds.db_port)
  description = "RDS database port"
}
