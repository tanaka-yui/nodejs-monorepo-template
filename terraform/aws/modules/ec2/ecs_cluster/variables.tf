variable "cluster_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "use_spot" {
  type    = bool
  default = false
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "auto_scaling" {
  type = object({
    desired_capacity = number
    min_size         = number
    max_size         = number
  })
  default = null
}

variable "capacity_provider" {
  type = object({
    maximum_scaling_step_size = number
    minimum_scaling_step_size = number
    target_capacity           = number
    base                      = number
    weight                    = number
  })
  default = ({
    maximum_scaling_step_size = 10
    minimum_scaling_step_size = 1
    target_capacity           = 100
    base                      = 0
    weight                    = 1
  })
}

variable "image_id" {
  type    = string
  default = ""
}

variable "gpu_support" {
  type    = bool
  default = false
}

variable "user_data" {
  type    = string
  default = null
}

variable "mount_s3_bucket_arn" {
  type    = string
  default = ""
}

variable "ebs_root" {
  type = object({
    delete_on_termination = bool
    encrypted             = bool
    volume_size           = number
    volume_type           = string
  })
  default = null
}