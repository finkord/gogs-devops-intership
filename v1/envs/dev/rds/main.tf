resource "random_password" "rds_password" {
  length  = 16
  special = true
}

module "rds_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "rds-sg"
  description = "Security group for RDS allowing access from ECS"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      description              = "PostgreSQL from ECS tasks"
      source_security_group_id = data.terraform_remote_state.ecs.outputs.security_group_id
    }
  ]

  egress_rules = ["all-all"]
  tags = {
    Name = "rds-sg"
  }
}

module "rds-finkord" {
  source = "../../../modules/rds-finkord"

  project            = "gogs"
  db_name            = "gogs"
  username           = "gogs"
  password           = random_password.rds_password.result
  subnet_ids         = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  security_group_ids = [module.rds_sg.security_group_id]
}

module "ssm-parameters-finkord" {
  source      = "../../../modules/ssm-parameters-finkord"
  project     = "gogs"
  db_name     = "gogs"
  db_username = "gogs"
  db_password = random_password.rds_password.result
  db_host     = module.rds-finkord.endpoint
  db_port     = module.rds-finkord.port
}
