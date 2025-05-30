variable "name" {
  type        = string
  description = "The name of the variable"
}

variable "region" {
  type        = string
  description = "The region"
}

variable "vpc_id" {
  type        = string
  description = "The vpc id"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The subnet ids"
}

variable "route_tables" {
  type        = list(string)
  description = "The route tables"
}