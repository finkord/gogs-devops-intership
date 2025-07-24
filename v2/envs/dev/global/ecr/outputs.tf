# ecr/outputs.tf
output "ecr_repository_urls" {
  description = "URLs of the ECR repositories"
  value = {
    for k, v in module.ecr : k => v.repository_url
  }
}

output "ecr_repository_arns" {
  description = "ARNs of the ECR repositories"
  value = {
    for k, v in module.ecr : k => v.repository_arn
  }
}

output "ecr_repository_names" {
  description = "Names of the ECR repositories"
  value = {
    for k, v in module.ecr : k => v.repository_name
  }
}
