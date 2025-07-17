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

module "ssm-parameters" {
  source      = "../../../modules/ssm-parameters"
  project     = "gogs"
  db_name     = "gogs"
  db_username = "gogs"
  db_password = random_password.rds_password.result
  db_host     = module.rds.endpoint_address
  db_port     = module.rds.port
}
