output "terraform_deployer_user_name" {
  description = "IAM user name for Terraform deployer"
  value       = aws_iam_user.terraform_deployer.name
}

output "terraform_deployer_user_arn" {
  description = "IAM user ARN for Terraform deployer"
  value       = aws_iam_user.terraform_deployer.arn
}

output "ecs_task_execution_role_name" {
  description = "Name of the ECS task execution IAM role"
  value       = aws_iam_role.ecs_task_execution_role.name
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution IAM role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "cloudwatch_logs_full_access_policy_arn" {
  description = "ARN of the custom CloudWatch Logs full access policy"
  value       = aws_iam_policy.cloudwatch_logs_full_access.arn
}

output "ecs_task_execution_policy_arn" {
  description = "ARN of the custom ECS Task Execution policy"
  value       = aws_iam_policy.ecs_task_execution_policy.arn
}

output "administrator_access_custom_policy_arn" {
  description = "ARN of the custom AdministratorAccess policy"
  value       = aws_iam_policy.administrator_access_custom.arn
}

output "jenkins_ecr_user_name" {
  description = "IAM user name for Jenkins ECR"
  value       = aws_iam_user.jenkins_ecr.name
}

output "jenkins_ecr_user_arn" {
  description = "IAM user ARN for Jenkins ECR"
  value       = aws_iam_user.jenkins_ecr.arn
}
