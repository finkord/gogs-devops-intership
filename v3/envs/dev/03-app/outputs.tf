output "ssm_endpoint_id" {
  description = "SSM endpoint ID"
  value       = module.endpoints.endpoints["ssm"].id
}

output "ssm_endpoint_dns" {
  description = "SSM endpoint DNS name"
  value       = module.endpoints.endpoints["ssm"].dns_entry
}

# output "ssmmessages_endpoint_id" {
#   description = "SSM Messages endpoint ID"
#   value       = module.endpoints.endpoints["ssmmessages"].id
# }

# output "ec2messages_endpoint_id" {
#   description = "EC2 Messages endpoint ID"
#   value       = module.endpoints.endpoints["ec2messages"].id
# }

output "logs_endpoint_id" {
  description = "CloudWatch Logs endpoint ID"
  value       = module.endpoints.endpoints["logs"].id
}

output "ecr_api_endpoint_id" {
  description = "ECR API endpoint ID"
  value       = module.endpoints.endpoints["ecr_api"].id
}

output "ecr_dkr_endpoint_id" {
  description = "ECR DKR endpoint ID"
  value       = module.endpoints.endpoints["ecr_dkr"].id
}

output "all_interface_endpoints" {
  description = "Map of all interface endpoints"
  value       = module.endpoints.endpoints
}


output "alb_arn" {
  value       = aws_lb.gogs.arn
  description = "ARN of the Gogs ALB"
}

output "alb_dns_name" {
  value       = aws_lb.gogs.dns_name
  description = "DNS name of the Gogs ALB"
}

output "alb_zone_id" {
  value       = aws_lb.gogs.zone_id
  description = "Route53 zone ID to use in alias"
}

output "alb_listener_arn" {
  value       = aws_lb_listener.gogs_http.arn
  description = "ARN of the HTTP listener"
}

output "alb_target_group_arn" {
  value       = aws_lb_target_group.gogs.arn
  description = "ARN of the ALB target group"
}
