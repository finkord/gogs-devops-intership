resource "aws_iam_user" "terraform_deployer" {
  name = "terraform-deployer"
}

resource "aws_iam_policy" "administrator_access_custom" {
  name = "AdministratorAccessCustom"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_admin_policy" {
  user       = aws_iam_user.terraform_deployer.name
  policy_arn = aws_iam_policy.administrator_access_custom.arn
}

resource "aws_iam_access_key" "terraform_deployer_key" {
  user = aws_iam_user.terraform_deployer.name
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
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ECSTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_logs_full_access" {
  name = "CloudWatchLogsFullAccess"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CloudWatchLogsFullAccess"
        Effect = "Allow"
        Action = [
          "logs:*",
          "cloudwatch:GenerateQuery",
          "cloudwatch:GenerateQueryResultsSummary"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_task_execution_policy" {
  name = "AmazonECSTaskExecutionRolePolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_full_access.arn
}

resource "aws_iam_role_policy_attachment" "attach_ecs_execution" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
}
