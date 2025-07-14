module "ecs_tasks_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ecs-tasks-sg"
  description = "SG for ECS tasks"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  egress_rules = ["all-all"]
  tags = {
    Name = "ecs-tasks-sg"
  }
}

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

