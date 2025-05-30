variable "name" {
  type = string
}

variable "enable_managed_encryption" {
  type    = bool
  default = false
}

variable "expiration_days" {
  type    = number
  default = 0
}