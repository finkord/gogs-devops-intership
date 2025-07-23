module "route53" {
  source = "../../../../v3.5/modules/route53-v1.0"

  domain_name = "awsgogs.pp.ua"
  san_names   = ["jenkins.awsgogs.pp.ua"]

  env = var.env
}
