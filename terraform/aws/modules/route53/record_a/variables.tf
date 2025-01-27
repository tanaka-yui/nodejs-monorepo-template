variable "zone_id" {
  type = string
}

variable "domain" {
  type = string
}

variable "ttl" {
  type    = number
  default = 300
}

variable "records" {
  type    = list(string)
  default = []
}