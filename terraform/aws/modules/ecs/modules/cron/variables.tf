variable "name" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "account_id" {
  type = string
}

variable "schedule_expression" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "cluster_arn" {
  type = string
}

variable "task_definition_arn" {
  type = string
}

variable "task_definition_arn_without_revision" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "assign_public_ip" {
  type    = bool
  default = false
}

variable "task_count" {
  type    = number
  default = 1
}

variable "s3_certificate_arn" {
  type = string
}

variable "secret_arn" {
  type = string
}