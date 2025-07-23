########################

# VPC/ free ✅

# SG/ free ✅

# ROUTE53/ one-pay and free after ✅

##########################

# IAM/ free ✅

module "vpc" {
  source = "../../../modules/vpc-v1.0"

  name = "gogs-vpc"
  cidr = "10.1.0.0/21"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.1.0.0/24", "10.1.1.0/24"]
  private_subnets = ["10.1.2.0/24", "10.1.3.0/24"]

  enable_nat_gateway     = false
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false

  default_security_group_name = "gogs-vpc-default-sg"
  default_security_group_ingress = [
    {
      description = "Allow all inbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  default_security_group_egress = [
    {
      description = "Allow all outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  env = var.env
}

module "sg" {
  source = "../../../modules/sg-v1.0"

  vpc_name = module.vpc.name
  env      = var.env
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = module.vpc.cidr
}

module "route53" {
  source = "../../../modules/route53-v1.0"

  domain_name = "awsgogs.pp.ua"
  san_names   = ["jenkins.awsgogs.pp.ua"]

  env = var.env
}

module "alb" {
  source = "../../../modules/alb-v1.0"

  alb_name           = "gogs-alb"
  internal           = false
  security_group_ids = [module.alb_sg.security_group_id]
  public_subnet_ids  = module.vpc.public_subnets

  enable_deletion_protection = false
  env                        = var.env
  tags                       = {}

  vpc_id          = module.vpc.vpc_id
  certificate_arn = module.route53.certificate_arn
  domain_name     = "awsgogs.pp.ua"
  route53_zone_id = module.route53.zone_id

  enable_jenkins      = true
  jenkins_instance_id = "i-0dc5a1a1cd564b718"
  jenkins_domain_name = "jenkins.awsgogs.pp.ua"
}
