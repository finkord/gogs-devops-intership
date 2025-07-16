
output "route53_zone_id" {
  value = aws_route53_zone.primary.zone_id
}

output "certificate_arn" {
  value = aws_acm_certificate_validation.gogs_cert_validation.certificate_arn
}
