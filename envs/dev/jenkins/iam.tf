# Jenkins IAM User Configuration
# Creates IAM user with EC2 management permissions for Jenkins CI/CD

locals {
  jenkins_user_name = "jenkins"
  policy_name       = "JenkinsEC2Policy"
}

resource "aws_iam_role" "jenkins_master" {
  name = "jenkins-master-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "jenkins_master_policy" {
  name = "jenkins-master-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "ec2:DescribeSpotInstanceRequests",
          "ec2:CancelSpotInstanceRequests",
          "ec2:GetConsoleOutput",
          "ec2:RequestSpotInstances",
          "ec2:RunInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:TerminateInstances",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeRegions",
          "ec2:DescribeImages",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "iam:ListInstanceProfilesForRole",
          "iam:PassRole",
          "ec2:GetPasswordData",
          "ec2:DescribeSpotPriceHistory"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_master" {
  policy_arn = aws_iam_policy.jenkins_master_policy.arn
  role       = aws_iam_role.jenkins_master.name
}

resource "aws_iam_instance_profile" "jenkins_master" {
  name = "jenkins-master-profile"
  role = aws_iam_role.jenkins_master.name
}

##################################
##################################

resource "aws_iam_role" "jenkins_agent" {
  name = "jenkins-agent-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "jenkins_agent" {
  name = "jenkins-agent-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:GetAuthorizationToken",
          "ecr:CompleteLayerUpload"
        ]
        Resource : "*"
        # Resource = [data.terraform_remote_state.ecr.outputs.ecr_repository_arn]
      },
      {
        "Effect" : "Allow",
        "Action" : "ecs:UpdateService",
        "Resource" : "arn:aws:ecs:us-east-1:416929699302:service/gogs-cluster/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_agent" {
  role       = aws_iam_role.jenkins_agent.name
  policy_arn = aws_iam_policy.jenkins_agent.arn
}

resource "aws_iam_instance_profile" "jenkins_agent" {
  name = "jenkins-agent-profile"
  role = aws_iam_role.jenkins_agent.name
}
