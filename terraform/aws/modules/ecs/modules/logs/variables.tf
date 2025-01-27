variable "env" {
  type = string
}

variable "name" {
  type = string
}

variable "log_retention_in_days" {
  type    = number
  default = 1
}

variable "archive_log_expiration_days" {
  type    = number
  default = 0
}

variable "use_proxy_log" {
  type    = bool
  default = false
}