resource "aws_ecs_task_definition" "gogs_task" {
  family                   = "gogs-task"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  # task_role_arn      = aws_iam_role.ecs_task_role.arn
  # execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn = data.terraform_remote_state.iam.outputs.ecs_task_execution_role_arn

  volume {
    name = "efs-volume"

    efs_volume_configuration {
      file_system_id     = data.terraform_remote_state.efs.outputs.efs_file_system_id
      root_directory     = "/"
      transit_encryption = "ENABLED"
    }
  }

  container_definitions = jsonencode([
    {
      name      = "gogs"
      image     = "416929699302.dkr.ecr.us-east-1.amazonaws.com/gogs/test:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "GOGS_DB_HOST"
          value = data.aws_ssm_parameter.db_host.value
        },
        {
          name  = "GOGS_DB_PORT"
          value = data.aws_ssm_parameter.db_port.value
        },
        {
          name  = "GOGS_DB_USER"
          value = data.aws_ssm_parameter.db_user.value
        },
        {
          name  = "GOGS_DB_PASSWORD"
          value = data.aws_ssm_parameter.db_password.value
        },
        {
          name  = "GOGS_DB_NAME"
          value = data.aws_ssm_parameter.db_name.value
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "efs-volume"
          containerPath = "/data"
          readOnly      = false
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/gogs"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}
