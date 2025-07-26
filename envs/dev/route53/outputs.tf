output "zone_id" {
  value = module.route53.zone_id
}

output "certificate_arn" {
  value = module.route53.certificate_arn
}

output "certificate_validation_status" {
  value = module.route53.certificate_validation_status
}
