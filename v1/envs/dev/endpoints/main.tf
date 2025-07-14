# Security group for ECR interface endpoints
locals {
  ingress_https_private = [
    for cidr in data.terraform_remote_state.vpc.outputs.private_subnet_cidrs : {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = cidr
      description = "Allow HTTPS from private subnets"
    }
  ]
}

module "endpoints_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ecr-vpc-endpoints-sg"
  description = "Security group for ECR VPC endpoints"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = local.ingress_https_private

  # ingress_with_cidr_blocks = [
  #   {
  #     from_port   = 443
  #     to_port     = 443
  #     protocol    = "tcp"
  #     cidr_blocks = data.terraform_remote_state.vpc.outputs.private_subnet_cidrs
  #     description = "Allow HTTPS from private subnets"
  #   }
  # ]

  egress_rules = ["all-all"]

  tags = {
    Name = "ecr-vpc-endpoints-sg"
  }
}

# ECR API VPC Endpoint (Interface)
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  service_name       = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  security_group_ids = [module.endpoints_sg.security_group_id]

  private_dns_enabled = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchDeleteImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name = "ecr-api-endpoint"
  }
}

# ECR DKR VPC Endpoint (Interface)
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  service_name       = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  security_group_ids = [module.endpoints_sg.security_group_id]

  private_dns_enabled = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name = "ecr-dkr-endpoint"
  }
}

# S3 VPC Endpoint (Gateway)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = data.terraform_remote_state.vpc.outputs.private_route_table_ids

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:ListAllMyBuckets"
        ]
        Resource = [
          "arn:aws:s3:::*",
          "arn:aws:s3:::*/*"
        ]
      }
    ]
  })

  tags = {
    Name = "s3-gateway-endpoint"
  }
}

# EFS API endpoint
resource "aws_vpc_endpoint" "efs" {
  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.efs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  security_group_ids  = [module.endpoints_sg.security_group_id]
  private_dns_enabled = true
}

# EFS mount target endpoint
resource "aws_vpc_endpoint" "efs_mount_targets" {
  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.efs.mount-targets"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  security_group_ids  = [module.endpoints_sg.security_group_id]
  private_dns_enabled = true
}

# SSM endpoint
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  security_group_ids  = [module.endpoints_sg.security_group_id]
  private_dns_enabled = true
}

# SSMMessages endpoint
resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  security_group_ids  = [module.endpoints_sg.security_group_id]
  private_dns_enabled = true
}

# EC2Messages endpoint
resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  security_group_ids  = [module.endpoints_sg.security_group_id]
  private_dns_enabled = true
}
