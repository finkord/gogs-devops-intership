variable "domain_name" {
  type = string
}

variable "san_names" {
  type    = list(string)
  default = []
}

variable "route53_zone_name" {
  type    = string
  default = "gogs-route53-zone"
}

variable "env" {
  type = string
}

