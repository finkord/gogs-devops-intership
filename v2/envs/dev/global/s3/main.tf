# s3/locals.tf
locals {
  bucket_name = "${var.project_name}-tfstate-${var.env}"
}

# s3/main.tf
# S3 bucket for Terraform state
resource "aws_s3_bucket" "tf_state" {
  bucket = local.bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

# Bucket versioning
resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}
