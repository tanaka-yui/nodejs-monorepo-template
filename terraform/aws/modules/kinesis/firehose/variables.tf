variable "account_id" {}

variable "region" {}

variable "name" {}

variable "log_retention_in_days" {
  type = number
}

variable "archive_log_expiration_days" {
  type    = number
  default = 0
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
