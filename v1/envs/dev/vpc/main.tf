module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "gogs-vpc"
  cidr = "10.1.0.0/21"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.1.0.0/24", "10.1.1.0/24"]
  private_subnets = ["10.1.2.0/24", "10.1.3.0/24"]

  enable_nat_gateway     = false
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
  }
}
