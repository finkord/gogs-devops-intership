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

#########################################################
#########################################################

resource "aws_iam_user" "jenkins_ecr" {
  name = "Jenkins-ecr-user"
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


