resource "random_password" "rds_password" {
  length  = 16
  special = true
}

module "rds-finkord" {
  source = "../../../modules/rds-finkord"

  project            = "gogs"
  db_name            = "gogs"
  username           = "gogs"
  password           = random_password.rds_password.result
  subnet_ids         = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  security_group_ids = [data.terraform_remote_state.vpc.outputs.default_security_group_id]
}
