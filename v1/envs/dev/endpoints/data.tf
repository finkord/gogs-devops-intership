data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "finkord-gogs-tfstate"
    key    = "envs/dev/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}
