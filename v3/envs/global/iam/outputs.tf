output "terraform_deployer_user_name" {
  description = "IAM user name for Terraform deployer"
  value       = aws_iam_user.terraform_deployer.name
}

output "terraform_deployer_user_arn" {
  description = "IAM user ARN for Terraform deployer"
  value       = aws_iam_user.terraform_deployer.arn
}

output "terraform_deployer_access_key_id" {
  description = "Access key ID for the terraform-deployer user"
  value       = aws_iam_access_key.terraform_deployer_key.id
}

output "terraform_deployer_secret_access_key" {
  description = "Secret access key for the terraform-deployer user"
  value       = aws_iam_access_key.terraform_deployer_key.secret
  sensitive   = true
}

#########################################################
#########################################################

output "jenkins_ecr_user_name" {
  description = "IAM user name for Jenkins ECR"
  value       = aws_iam_user.jenkins_ecr.name
}

output "jenkins_ecr_user_arn" {
  description = "IAM user ARN for Jenkins ECR"
  value       = aws_iam_user.jenkins_ecr.arn
}

output "jenkins_ecr_access_key_id" {
  description = "Access key ID for the Jenkins ECR user"
  value       = aws_iam_access_key.jenkins_ecr_key.id
}

output "jenkins_ecr_secret_access_key" {
  description = "Secret access key for the Jenkins ECR user"
  value       = aws_iam_access_key.jenkins_ecr_key.secret
  sensitive   = true
}
