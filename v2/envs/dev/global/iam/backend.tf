# ecr/backend.tf
terraform {
  backend "s3" {
    bucket       = "finkord-gogs-tfstate"
    key          = "envs/global/iam/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
