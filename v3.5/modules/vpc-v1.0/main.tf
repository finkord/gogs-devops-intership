module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = var.cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  enable_vpn_gateway     = var.enable_vpn_gateway

  default_security_group_name = var.default_security_group_name
  default_security_group_tags = {
    Name        = var.default_security_group_name
    Environment = var.env
  }
  default_security_group_ingress = var.default_security_group_ingress
  default_security_group_egress  = var.default_security_group_egress

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

module "endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = []

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = module.vpc.private_route_table_ids
      tags = {
        Name = "s3-${var.name}-endpoint"
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}
