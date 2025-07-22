output "endpoints_sg_id" {
  description = "The ID of the security group for future Interface-type VPC endpoints"
  value       = module.endpoints_sg.security_group_id
}

output "endpoints_sg_name" {
  value = module.endpoints_sg.security_group_name
}

output "ecs_tasks_sg_id" {
  value = module.ecs_tasks_sg.security_group_id
}

output "ecs_tasks_sg_name" {
  value = module.ecs_tasks_sg.security_group_name
}

output "rds_sg_id" {
  value = module.rds_sg.security_group_id
}

output "rds_sg_name" {
  value = module.rds_sg.security_group_name
}

output "efs_sg_id" {
  value = module.efs_sg.security_group_id
}

output "efs_sg_name" {
  value = module.efs_sg.security_group_name
}

output "alb_sg_id" {
  value = module.alb_sg.security_group_id
}

output "alb_sg_name" {
  value = module.alb_sg.security_group_name
}
