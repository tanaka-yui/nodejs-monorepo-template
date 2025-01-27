variable "name" {}

variable "certificate_arn" {
  type    = string
  default = ""
}

variable "enable_deletion_protection" {
  type    = bool
  default = true
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "ssl_policy" {
  type    = string
  default = "ELBSecurityPolicy-2016-08"
}

variable "port" {
  type = string
}

variable "path_pattern" {
  type    = string
  default = "/*"
}

variable "health_check_path" {
  type = string
}

variable "access_log_bucket" {
  type    = string
  default = null
}

variable "access_log_prefix" {
  type    = string
  default = null
}

variable "health_check_matcher" {
  type    = string
  default = "200"
}


variable "alb_custom_header" {
  type = list(object({
    http_header_name = string
    value            = string
  }))
  default = []
}

variable "origin_access_key_name" {
  type    = string
  default = "x-origin-access-key"
}

variable "use_origin_access_key" {
  type    = bool
  default = false
}