output "endpoints_sg_id" {
  description = "Security Group ID for VPC Endpoints"
  value       = module.endpoints_sg.security_group_id
}

output "alb_sg_id" {
  description = "Security Group ID for Application Load Balancer"
  value       = module.alb_sg.security_group_id
}

output "ecs_tasks_sg_id" {
  description = "Security Group ID for ECS Tasks"
  value       = module.ecs_tasks_sg.security_group_id
}

output "rds_sg_id" {
  description = "Security Group ID for RDS Database"
  value       = module.rds_sg.security_group_id
}

output "efs_sg_id" {
  description = "Security Group ID for EFS File System"
  value       = module.efs_sg.security_group_id
}

output "jenkins_sg_id" {
  description = "Security Group ID for Jenkins Server"
  value       = module.jenkins_sg.security_group_id
}
