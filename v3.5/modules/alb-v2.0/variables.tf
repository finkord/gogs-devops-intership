variable "alb_name" {
  type = string
}

variable "internal" {
  type    = bool
  default = false
}

variable "security_group_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "env" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_id" {
  type = string
}

variable "gogs_target_group_name" {
  type    = string
  default = "gogs-tg"
}

variable "gogs_target_group_port" {
  type    = number
  default = 3000
}

variable "gogs_target_group_protocol" {
  type    = string
  default = "HTTP"
}

variable "gogs_target_group_target_type" {
  type    = string
  default = "ip"
}

variable "gogs_health_check_path" {
  type    = string
  default = "/"
}

variable "gogs_health_check_protocol" {
  type    = string
  default = "HTTP"
}

variable "gogs_health_check_matcher" {
  type    = string
  default = "200"
}

variable "gogs_health_check_interval" {
  type    = number
  default = 30
}

variable "gogs_health_check_timeout" {
  type    = number
  default = 5
}

variable "gogs_health_check_healthy_threshold" {
  type    = number
  default = 2
}

variable "gogs_health_check_unhealthy_threshold" {
  type    = number
  default = 3
}

variable "ssl_policy" {
  type    = string
  default = "ELBSecurityPolicy-2016-08"
}

variable "certificate_arn" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "route53_zone_id" {
  type = string
}

# Jenkins variables

variable "enable_jenkins" {
  type    = bool
  default = false
}

variable "jenkins_target_group_name" {
  type    = string
  default = "jenkins-tg"
}

variable "jenkins_target_group_protocol" {
  type    = string
  default = "HTTP"
}

variable "jenkins_target_group_target_type" {
  type    = string
  default = "instance"
}

variable "jenkins_health_check_path" {
  type    = string
  default = "/login"
}

variable "jenkins_health_check_protocol" {
  type    = string
  default = "HTTP"
}

variable "jenkins_health_check_matcher" {
  type    = string
  default = "200"
}

variable "jenkins_health_check_interval" {
  type    = number
  default = 30
}

variable "jenkins_health_check_timeout" {
  type    = number
  default = 5
}

variable "jenkins_health_check_healthy_threshold" {
  type    = number
  default = 2
}

variable "jenkins_health_check_unhealthy_threshold" {
  type    = number
  default = 3
}

variable "jenkins_domain_name" {
  type    = string
  default = ""
}

variable "jenkins_redirect_priority" {
  type    = number
  default = 5
}

variable "jenkins_host_rule_priority" {
  type    = number
  default = 10
}

variable "jenkins_target_group_port" {
  type    = number
  default = 8080
}
