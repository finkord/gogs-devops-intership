# ecr/variables.tf
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "gogs"
}

variable "repositories" {
  description = "Map of ECR repositories to create"
  type = map(object({
    description          = optional(string, "")
    image_tag_mutability = optional(string, "MUTABLE")
    scan_on_push         = optional(bool, true)
    force_delete         = optional(bool, false)
    keep_main_images     = optional(number, 2)
    keep_develop_images  = optional(number, 2)
    keep_untagged_images = optional(number, 1)
    keep_total_images    = optional(number, 3)
  }))
  default = {
    "test" = {
      description          = "Test application repository"
      keep_main_images     = 2
      keep_develop_images  = 2
      keep_untagged_images = 1
      keep_total_images    = 3
      force_delete         = true
    }
  }
}
