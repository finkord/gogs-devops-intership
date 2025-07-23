output "alb_arn" {
  description = "ARN of the Gogs ALB"
  value       = module.alb.alb_arn
}

output "alb_dns_name" {
  description = "DNS name of the Gogs ALB"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Route53 zone ID to use in alias"
  value       = module.alb.alb_zone_id
}

output "gogs_target_group_arn" {
  value = module.alb.gogs_target_group_arn
}

output "jenkins_target_group_arn" {
  value = module.alb.jenkins_target_group_arn
}
