# Security group for ECR interface endpoints
resource "aws_security_group" "ecr_endpoints" {
  name        = "ecr-vpc-endpoints-sg"
  description = "Security group for ECR VPC endpoints"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = data.terraform_remote_state.vpc.outputs.private_subnet_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
  security_group_ids = [aws_security_group.ecr_endpoints.id]

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
  security_group_ids = [aws_security_group.ecr_endpoints.id]

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
