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
    target_group_arn = data.terraform_remote_state.alb.outputs.alb_target_group_arn
    container_name   = "gogs"
    container_port   = 3000
  }
}
