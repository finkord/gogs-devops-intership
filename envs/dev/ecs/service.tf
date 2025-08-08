resource "aws_ecs_service" "gogs" {
  name            = "gogs-service"
  cluster         = aws_ecs_cluster.gogs.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.gogs_task.arn
  desired_count   = 1

  network_configuration {
    subnets          = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    security_groups  = [data.terraform_remote_state.sg.outputs.ecs_tasks_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = data.terraform_remote_state.alb.outputs.gogs_target_group_arn
    container_name   = "gogs"
    container_port   = 3000
  }
}

resource "aws_appautoscaling_target" "gogs" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.gogs.name}/${aws_ecs_service.gogs.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "gogs_cpu" {
  name               = "cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.gogs.resource_id
  scalable_dimension = aws_appautoscaling_target.gogs.scalable_dimension
  service_namespace  = aws_appautoscaling_target.gogs.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 60.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_policy" "gogs_memory" {
  name               = "memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.gogs.resource_id
  scalable_dimension = aws_appautoscaling_target.gogs.scalable_dimension
  service_namespace  = aws_appautoscaling_target.gogs.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 70.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

