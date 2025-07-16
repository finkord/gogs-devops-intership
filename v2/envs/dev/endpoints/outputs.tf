output "ssm_endpoint_id" {
  description = "SSM endpoint ID"
  value       = module.endpoints.endpoints["ssm"].id
}

output "ssm_endpoint_dns" {
  description = "SSM endpoint DNS name"
  value       = module.endpoints.endpoints["ssm"].dns_entry
}

output "ssmmessages_endpoint_id" {
  description = "SSM Messages endpoint ID"
  value       = module.endpoints.endpoints["ssmmessages"].id
}

output "ec2messages_endpoint_id" {
  description = "EC2 Messages endpoint ID"
  value       = module.endpoints.endpoints["ec2messages"].id
}

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
