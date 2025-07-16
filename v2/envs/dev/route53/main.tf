
resource "aws_route53_zone" "primary" {
  name = "awsgogs.pp.ua"

  tags = {
    Name = "gogs-route53-zone"
  }
}

resource "aws_acm_certificate" "gogs_cert" {
  domain_name       = "awsgogs.pp.ua"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  name    = tolist(aws_acm_certificate.gogs_cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.gogs_cert.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.primary.zone_id
  records = [tolist(aws_acm_certificate.gogs_cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "gogs_cert_validation" {
  certificate_arn         = aws_acm_certificate.gogs_cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
