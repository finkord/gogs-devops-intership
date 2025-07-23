module "alb" {
  source = "../../../../v3.5/modules/alb-v1.0"

  alb_name           = "gogs-alb"
  internal           = false
  security_group_ids = [data.terraform_remote_state.sg.outputs.alb_sg_id]
  public_subnet_ids  = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  enable_deletion_protection = false
  env                        = var.env
  tags                       = {}

  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  certificate_arn = data.terraform_remote_state.route53.outputs.certificate_arn
  domain_name     = "awsgogs.pp.ua"
  # route53_zone_id = module.route53.zone_id
  route53_zone_id = data.terraform_remote_state.route53.outputs.zone_id

  enable_jenkins      = true
  jenkins_instance_id = data.terraform_remote_state.jenkins.outputs.instance_id
  jenkins_domain_name = "jenkins.awsgogs.pp.ua"
}
