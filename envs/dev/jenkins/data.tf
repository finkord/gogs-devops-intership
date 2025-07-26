data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "finkord-gogs-tfstate"
    key    = "envs/dev/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "sg" {
  backend = "s3"
  config = {
    bucket = "finkord-gogs-tfstate"
    key    = "envs/dev/sg/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "ebs" {
  backend = "s3"
  config = {
    bucket = "finkord-gogs-tfstate"
    key    = "envs/dev/ebs/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "finkord-gogs-tfstate"
    key    = "envs/dev/iam/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = "finkord-gogs-tfstate"
    key    = "envs/dev/alb/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "ecr" {
  backend = "s3"
  config = {
    bucket = "finkord-gogs-tfstate"
    key    = "envs/dev/ecr/terraform.tfstate"
    region = "us-east-1"
  }
}
