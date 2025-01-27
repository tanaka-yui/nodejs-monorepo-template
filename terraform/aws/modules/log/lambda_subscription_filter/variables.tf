variable "lambda_function" {
  type = any
}

variable "log_group" {
  type = any
}

variable "filter_pattern" {
  type    = string
  default = ""
}