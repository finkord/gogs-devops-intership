
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

resource "aws_iam_role_policy" "allow_ssm_parameters" {
  name = "AllowGetSSMParameters"
  role = aws_iam_role.ecs_task_execution_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameters"
        ],
        Resource = [
          "arn:aws:ssm:us-east-1:416929699302:parameter/SPLUNK_HEC_TRACES_TOKEN",
          "arn:aws:ssm:us-east-1:416929699302:parameter/SPLUNK_HEC_METRICS_TOKEN",
          "arn:aws:ssm:us-east-1:416929699302:parameter/SPLUNK_HEC_LOGS_TOKEN",
          "arn:aws:ssm:us-east-1:416929699302:parameter/SPLUNK_ACCESS_TOKEN",
          "arn:aws:ssm:us-east-1:416929699302:parameter/SPLUNK_HEC_URL",
          "arn:aws:ssm:us-east-1:416929699302:parameter/SPLUNK_INGEST_URL",
          "arn:aws:ssm:us-east-1:416929699302:parameter/SPLUNK_API_URL"
        ]
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

#########################################################
#########################################################
resource "aws_iam_user" "jenkins_ecr" {
  name = "Jenkins-ecr"
}

resource "aws_iam_policy" "jenkins_ecr_policy" {
  name        = "Jenkins-ecr-policy"
  description = "Full ECR access with additional permissions for CloudTrail and service-linked role creation"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:*",
          "cloudtrail:LookupEvents"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "iam:CreateServiceLinkedRole"
        Resource = "*"
        Condition = {
          StringEquals = {
            "iam:AWSServiceName" = "replication.ecr.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "jenkins_ecr_attach" {
  user       = aws_iam_user.jenkins_ecr.name
  policy_arn = aws_iam_policy.jenkins_ecr_policy.arn
}

resource "aws_iam_access_key" "jenkins_ecr_key" {
  user = aws_iam_user.jenkins_ecr.name
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
