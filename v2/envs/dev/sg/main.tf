module "sg" {
  source = "../../../../v3.5/modules/sg-v1.0"

  vpc_name = data.terraform_remote_state.vpc.outputs.vpc_name
  env      = var.env
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_cidr = data.terraform_remote_state.vpc.outputs.vpc_cidr_block
}
