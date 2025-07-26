
variable "name" {}
variable "cidr" {}

variable "azs" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

variable "one_nat_gateway_per_az" {
  type    = bool
  default = false
}

variable "enable_vpn_gateway" {
  type    = bool
  default = false
}

variable "default_security_group_name" {
  type = string
}

variable "default_security_group_ingress" {
  type = list(any)
}

variable "default_security_group_egress" {
  type = list(any)
}

variable "env" {
  type = string
}
