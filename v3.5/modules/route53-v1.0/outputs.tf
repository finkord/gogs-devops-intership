output "zone_id" {
  value = aws_route53_zone.this.zone_id
}

output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

output "certificate_validation_status" {
  value = aws_acm_certificate.cert.status
}
