resource "aws_ecs_cluster" "gogs" {
  name = "gogs-cluster"
  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
  }
}

