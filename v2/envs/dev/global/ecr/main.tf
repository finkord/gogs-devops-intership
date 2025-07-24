# ECR repositories
module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  for_each = var.repositories

  repository_name                 = "${var.project_name}/${each.key}"
  repository_type                 = "private"
  repository_image_tag_mutability = each.value.image_tag_mutability
  repository_force_delete         = each.value.force_delete

  repository_image_scan_on_push = each.value.scan_on_push

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${each.value.keep_main_images} images with tag prefix main"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["main", "master"]
          countType     = "imageCountMoreThan"
          countNumber   = each.value.keep_main_images
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep last ${each.value.keep_develop_images} images with tag prefix develop"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["develop", "dev"]
          countType     = "imageCountMoreThan"
          countNumber   = each.value.keep_develop_images
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 8
        description  = "Keep last ${each.value.keep_untagged_images} untagged images"
        selection = {
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = each.value.keep_untagged_images
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 10
        description  = "Remove any other images beyond last ${each.value.keep_total_images} (catch-all)"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = each.value.keep_total_images
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
