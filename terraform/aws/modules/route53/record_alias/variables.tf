variable "zone_id" {
  type = string
}

variable "domain" {
  type = string
}

variable "ttl" {
  type    = number
  default = null
}

variable "alias" {
  type = object({
    name    = string
    zone_id = string
  })
  default = null
}

variable "records" {
  type    = list(string)
  default = []
}