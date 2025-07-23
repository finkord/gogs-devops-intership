terraform {
  backend "s3" {
    bucket       = "finkord-gogs-tfstate"
    key          = "envs/dev/test/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
