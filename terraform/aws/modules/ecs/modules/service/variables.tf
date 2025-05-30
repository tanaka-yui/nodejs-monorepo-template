variable "account_id" {}

variable "region" {}

variable "name" {}

variable "alb_setting" {
  type = object({
    container_name   = string
    container_port   = string
    target_group_arn = string
  })
  default = null
}

variable "efs_volume" {
  type = list(object({
    name           = string
    file_system_id = string
    root_directory = string
  }))
  default = []
}

variable "maintenance" {
  type    = bool
  default = false
}

variable "enable" {
  type    = bool
  default = true
}

variable "cluster" {
  type    = any
  default = null
}

variable "repository" {
  type    = any
  default = null
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "task_definition_arn" {
  type = string
}

variable "service" {
  type = object({
    launch_type      = string
    platform_version = string
    container_port   = number
    desired_count    = number
  })
}

variable "autoscale_capacity" {
  type = object({
    min                      = number
    max                      = number
    scale_down_cpu_threshold = number
    scale_up_cpu_threshold   = number
  })
  default = null
}

variable "deploy_mode" {
  type    = string
  default = "ECS"
}

variable "source_security_group_id" {
  type    = string
  default = null
}
