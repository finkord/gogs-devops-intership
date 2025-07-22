data "aws_ssm_parameter" "db_host" {
  name            = "/rds/gogs/db_host"
  with_decryption = false
}

data "aws_ssm_parameter" "db_port" {
  name            = "/rds/gogs/db_port"
  with_decryption = false
}

data "aws_ssm_parameter" "db_user" {
  name            = "/rds/gogs/db_username"
  with_decryption = false
}

data "aws_ssm_parameter" "db_password" {
  name            = "/rds/gogs/db_password"
  with_decryption = true
}

data "aws_ssm_parameter" "db_name" {
  name            = "/rds/gogs/db_name"
  with_decryption = false
}
