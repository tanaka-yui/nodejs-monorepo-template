variable "name" {
  type = string
}

variable "cpu" {
  type    = number
  default = 512
}

variable "memory" {
  type    = number
  default = 1024
}

variable "launch_type" {
  type = list(string)
  default = [
    "EC2",
    "FARGATE"
  ]
}

variable "container_definitions" {
  type = string
}

variable "efs_volume" {
  type = list(object({
    name           = string
    file_system_id = string
    root_directory = string
  }))
  default = []
}

variable "task_role" {
  type    = any
  default = null
}

variable "task_execution_role" {
  type    = any
  default = null
}
