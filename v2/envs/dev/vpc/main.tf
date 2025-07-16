# Creates the main VPC with public and private subnets across two AZs.
# Includes a default security group with open ingress and egress (not recommended for production).
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "gogs-vpc"
  cidr = "10.1.0.0/21"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.1.0.0/24", "10.1.1.0/24"]
  private_subnets = ["10.1.2.0/24", "10.1.3.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  # Open ingress and egress - wide-open security posture (adjust in production)
  default_security_group_name = "default-gogs-sg"
  default_security_group_tags = {
    Name        = "default-gogs-sg"
    Environment = "${var.env}"
  }
  default_security_group_ingress = [
    {
      description = "Allow all inbound"
      from_port   = "0"
      to_port     = "0"
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  default_security_group_egress = [
    {
      description = "Allow all outbound"
      from_port   = "0"
      to_port     = "0"
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
  }
}

# Creates an S3 Gateway VPC endpoint attached to private route tables.
# Allows ECS tasks or other private subnet resources to access S3 without internet access or NAT gateway.
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
        Name = "s3-gogs-vpc-endpoint"
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}


