variable "project" {
  type        = string
  description = "Project name used in parameter names"
}

variable "db_password" {
  type        = string
  description = "Database password"
  sensitive   = true
}

variable "db_username" {
  type        = string
  description = "Database username"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "db_host" {
  type        = string
  description = "Database endpoint/hostname"
}

variable "db_port" {
  type        = number
  description = "Database port"
}
