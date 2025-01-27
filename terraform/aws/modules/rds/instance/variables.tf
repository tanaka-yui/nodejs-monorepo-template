variable "env" {
  type = string
}

variable "name" {
  type = string
}

variable "database" {
  type = object({
    db_name                         = string
    master_username                 = string
    skip_final_snapshot             = bool
    performance_insights            = bool
    apply_immediately               = bool
    backup_window                   = string
    backup_retention_period         = number
    monitoring_interval             = number
    log_retention_in_days           = number
    reader_instance_count           = number
    reader_promotion_tier           = number
    min_capacity                    = number
    max_capacity                    = number
    enabled_cloudwatch_logs_exports = list(string)
  })
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "cidr_blocks" {
  type    = list(string)
  default = []
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}