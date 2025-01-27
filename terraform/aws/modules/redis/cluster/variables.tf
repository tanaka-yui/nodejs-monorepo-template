variable "env" {
  type = string
}

variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "cidr_blocks" {
  type = list(string)
}

variable "node_type" {
  type = string
}

variable "number_cache_clusters" {
  type = number
}
