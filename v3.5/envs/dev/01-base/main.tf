########################

# VPC/ free ✅

# SG/ free ✅

# ROUTE53/ one-pay and free after ✅

##########################

# IAM/ free ✅

module "vpc" {
  source = "../../../modules/vpc"
}
module "sg" {
  source = "../../../modules/sg"
}
module "route53" {
  source = "../../../modules/route53"
}
