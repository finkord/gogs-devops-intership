# Terraform Automation User Configuration
# Creates IAM user with full administrator privileges

locals {
  terraform_user_name = "terraform-automation"
}

# IAM user for Terraform operations
resource "aws_iam_user" "terraform_automation" {
  name = local.terraform_user_name

  tags = {
    Purpose     = "Terraform Automation"
    Environment = "Infrastructure"
  }
}

# Attach AWS managed AdministratorAccess policy
resource "aws_iam_user_policy_attachment" "attach_admin_policy" {
  user       = aws_iam_user.terraform_automation.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Access key for programmatic access
resource "aws_iam_access_key" "terraform_automation_key" {
  user = aws_iam_user.terraform_automation.name
}

# Outputs
output "terraform_automation_access_key_id" {
  description = "Access Key ID for terraform-automation user"
  value       = aws_iam_access_key.terraform_automation_key.id
}

output "terraform_automation_secret_access_key" {
  description = "Secret Access Key for terraform-automation user"
  value       = aws_iam_access_key.terraform_automation_key.secret
  sensitive   = true
}
