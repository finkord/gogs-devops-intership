# Creates a dedicated security group for future Interface-type VPC endpoints (e.g., ECR, CloudWatch).
# Allows inbound HTTPS from within the VPC CIDR and unrestricted egress.
module "endpoints_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "gogs-endpoints-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  description = "Security group for VPC interface endpoints"

  ingress_cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
  ingress_rules       = ["https-443-tcp"]

  egress_rules = ["all-all"]

  tags = {
    Environment = var.env
    Name        = "endpoints-gogs-sg"
  }
}

module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "alb-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  description = "Security group for ALB"

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_source_security_group_id = [
    {
      from_port                = 3000
      to_port                  = 3000
      protocol                 = "tcp"
      source_security_group_id = module.ecs_tasks_sg.security_group_id
    }
  ]

  # egress_rules = ["all-all"]

  tags = {
    Environment = var.env
    Name        = "alb-gogs-sg"
  }
}

module "ecs_tasks_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "ecs-tasks-gogs-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  description = "Security group for ECS tasks running Gogs app"

  ingress_with_source_security_group_id = [
    {
      from_port                = 3000
      to_port                  = 3000
      protocol                 = "tcp"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]

  # egress_cidr_blocks = data.terraform_remote_state.vpc.outputs.private_subnet_cidrs

  egress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = module.rds_sg.security_group_id
    },
    {
      from_port                = 2049
      to_port                  = 2049
      protocol                 = "tcp"
      source_security_group_id = module.efs_sg.security_group_id
    }
  ]

  egress_rules = ["all-all"]

  tags = {
    Environment = var.env
    Name        = "ecs-tasks-gogs-sg"
  }
}

module "rds_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "gogs-rds-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  description = "Security group for RDS allowing access from ECS"

  ingress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = module.ecs_tasks_sg.security_group_id
    }
  ]

  egress_rules = ["all-all"]

  tags = {
    Environment = var.env
    Name        = "rds-gogs-sg"
  }
}

module "efs_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "gogs-efs-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  description = "SG for EFS mount targets allowing ECS task access"


  ingress_with_source_security_group_id = [
    {
      from_port                = 2049
      to_port                  = 2049
      protocol                 = "tcp"
      source_security_group_id = module.ecs_tasks_sg.security_group_id
    }
  ]

  egress_rules = ["all-all"]

  tags = {
    Environment = var.env
    Name        = "efs-gogs-sg"
  }
}



