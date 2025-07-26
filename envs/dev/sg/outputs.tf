output "endpoints_sg_id" {
  description = "Security Group ID for VPC Endpoints"
  value       = module.sg.endpoints_sg_id
}

output "alb_sg_id" {
  description = "Security Group ID for Application Load Balancer"
  value       = module.sg.alb_sg_id
}

output "ecs_tasks_sg_id" {
  description = "Security Group ID for ECS Tasks"
  value       = module.sg.ecs_tasks_sg_id
}

output "rds_sg_id" {
  description = "Security Group ID for RDS Database"
  value       = module.sg.rds_sg_id
}

output "efs_sg_id" {
  description = "Security Group ID for EFS File System"
  value       = module.sg.efs_sg_id
}

output "jenkins_sg_id" {
  description = "Security Group ID for Jenkins Server"
  value       = module.sg.jenkins_sg_id
}
