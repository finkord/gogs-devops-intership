resource "aws_s3_bucket" "tf_state" {
  bucket = "finkord-gogs-tfstate"
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
