output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_zone_id" {
  value = aws_lb.this.zone_id
}

output "gogs_target_group_arn" {
  value = aws_lb_target_group.gogs.arn
}

output "jenkins_target_group_arn" {
  value = length(aws_lb_target_group.jenkins) > 0 ? aws_lb_target_group.jenkins[0].arn : ""
}
