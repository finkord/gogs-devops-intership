
locals {
  domain_name = "awsgogs.pp.ua"
  san_names   = ["jenkins.awsgogs.pp.ua"]
  all_domains = concat([local.domain_name], local.san_names)
}

resource "aws_route53_zone" "primary" {
  name = local.domain_name

  tags = {
    Name = "gogs-route53-zone"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_acm_certificate" "gogs_cert" {
  domain_name               = local.domain_name
  subject_alternative_names = local.san_names
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.gogs_cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.primary.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.value]
}

resource "aws_acm_certificate_validation" "gogs_cert_validation" {
  certificate_arn = aws_acm_certificate.gogs_cert.arn

  validation_record_fqdns = [
    for record in aws_route53_record.cert_validation : record.fqdn
  ]

  depends_on = [aws_route53_record.cert_validation]
}
