output "alb_arn" {
  value       = aws_lb.gogs.arn
  description = "ARN of the Gogs ALB"
}

output "alb_dns_name" {
  value       = aws_lb.gogs.dns_name
  description = "DNS name of the Gogs ALB"
}

output "alb_zone_id" {
  value       = aws_lb.gogs.zone_id
  description = "Route53 zone ID to use in alias"
}

output "alb_listener_arn" {
  value       = aws_lb_listener.gogs_http.arn
  description = "ARN of the HTTP listener"
}

output "alb_target_group_arn" {
  value       = aws_lb_target_group.gogs.arn
  description = "ARN of the ALB target group"
}
