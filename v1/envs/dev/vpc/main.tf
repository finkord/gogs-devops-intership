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


  default_security_group_name = "default-gogs-sg"
  default_security_group_tags = {
    Name        = "default-gogs-sg"
    Environment = "${var.env}"
  }

  default_security_group_ingress = [
    {
      description = "Allow SSH"
      from_port   = "22"
      to_port     = "22"
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "Allow HTTP"
      from_port   = "80"
      to_port     = "80"
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "Allow HTTPS"
      from_port   = "443"
      to_port     = "443"
      protocol    = "tcp"
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

# default_security_group_egress	List of maps of egress rules to set on the default security group	list(map(string))	[]	no
# default_security_group_ingress	List of maps of ingress rules to set on the default security group	list(map(string))	[]	no
# default_security_group_name	Name to be used on the default security group	string	null	no
# default_security_group_tags	Additional tags for the default security group	map(string)	{}	no
