terraform {
  backend "s3" {
    bucket       = "finkord-gogs-tfstate"
    key          = "envs/dev/s3/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}


