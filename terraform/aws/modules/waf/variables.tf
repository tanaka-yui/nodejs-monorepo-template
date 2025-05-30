variable "name" {
  type = string
}

variable "alb_arn" {
  type    = string
  default = ""
}

variable "scope" {
  type    = string
  default = "REGIONAL"
}

variable "logging" {
  type = object({
    enable              = bool
    delivery_stream_arn = string
  })
}

variable "ip_whitelist" {
  type    = list(string)
  default = []
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

variable "bot_control_web" {
  type    = bool
  default = false
}

variable "bot_control_api_key" {
  type    = string
  default = null
}