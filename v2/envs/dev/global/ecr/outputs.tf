# ecr/outputs.tf
# output "ecr_repository_urls" {
#   description = "URLs of the ECR repositories"
#   value = {
#     for k, v in module.ecr : k => v.repository_url
#   }
# }

# output "ecr_repository_arns" {
#   description = "ARNs of the ECR repositories"
#   value = {
#     for k, v in module.ecr : k => v.repository_arn
#   }
# }

# output "ecr_repository_names" {
#   description = "Names of the ECR repositories"
#   value = {
#     for k, v in module.ecr : k => v.repository_name
#   }
# }

output "ecr_repository_name" {
  value = module.ecr.repository_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecr_repository_arn" {
  value = module.ecr.repository_arn
}

output "ecr_repository_registry_id" {
  value = module.ecr.repository_registry_id
}
