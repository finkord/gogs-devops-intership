resource "aws_ssm_parameter" "db_password" {
  name        = "/rds/${var.project}/db_password"
  type        = "SecureString"
  value       = var.db_password
  description = "RDS database password for project ${var.project}"
}

resource "aws_ssm_parameter" "db_username" {
  name        = "/rds/${var.project}/db_username"
  type        = "String"
  value       = var.db_username
  description = "RDS database username"
}

resource "aws_ssm_parameter" "db_name" {
  name        = "/rds/${var.project}/db_name"
  type        = "String"
  value       = var.db_name
  description = "RDS database name"
}

resource "aws_ssm_parameter" "db_host" {
  name        = "/rds/${var.project}/db_host"
  type        = "String"
  value       = var.db_host
  description = "RDS database endpoint"
}

resource "aws_ssm_parameter" "db_port" {
  name        = "/rds/${var.project}/db_port"
  type        = "String"
  value       = tostring(var.db_port)
  description = "RDS database port"
}
