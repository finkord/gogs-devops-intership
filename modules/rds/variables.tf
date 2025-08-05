variable "project" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "engine_version" {
  type    = string
  default = "16.9"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "storage_type" {
  type    = string
  default = "gp2"
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "rds_monitoring_role_arn" {
  type = string
}
