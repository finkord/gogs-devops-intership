# ------------------------------------------------------------------------------
# S3 Bucket for Terraform Remote State Storage
#
# This resource block provisions an S3 bucket
# intended to store the Terraform backend state for the Gogs infrastructure.
#
# Versioning is enabled to preserve the history of state files and allow rollback
# in case of accidental corruption or destructive changes.
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "tf_state" {
  bucket = "finkord-gogs-tfstate"
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
