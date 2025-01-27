variable "name" {
  type = string
}

variable "log_types" {
  type = list(string)
}

variable "log_retention_in_days" {
  type = number
}
