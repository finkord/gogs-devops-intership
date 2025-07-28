module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name                 = "gogs/test"
  repository_type                 = "private"
  repository_image_tag_mutability = "MUTABLE"
  repository_force_delete         = false
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 5 images with tag prefix prod"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["prod"]
          countType     = "imageCountMoreThan"
          countNumber   = 3
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep last 2 images with tag prefix main"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["main", "master"]
          countType     = "imageCountMoreThan"
          countNumber   = 2
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 3
        description  = "Keep last 2 images with tag prefix develop"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["develop", "dev"]
          countType     = "imageCountMoreThan"
          countNumber   = 2
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 8
        description  = "Keep last 1 untagged images"
        selection = {
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 10
        description  = "Remove any other images beyond last 3 (catch-all)"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
  }
}
