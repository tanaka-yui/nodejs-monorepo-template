variable "env" {
  default = ""
}

variable "name" {
  type = string
}

variable "domain" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "waf_arn" {
  type    = string
  default = ""
}

variable "enable_normal_logging" {
  type    = bool
  default = false
}

variable "custom_s3_origin" {
  type = list(object({
    domain_name                     = string
    origin_id                       = string
    cloudfront_access_identity_path = string
  }))
  default = []
}

variable "custom_api_origin" {
  type = list(object({
    domain_name            = string
    origin_id              = string
    origin_access_key_name = string
    origin_access_key      = string
  }))
  default = []
}

variable "custom_ordered_cache_behavior" {
  type = list(object({
    path_pattern             = string
    allowed_methods          = list(string)
    cached_methods           = list(string)
    viewer_protocol_policy   = string
    target_origin_id         = string
    cache_policy_id          = string
    origin_request_policy_id = string
    compress                 = bool
    trusted_key_groups       = list(string)
  }))
  default = []
}

variable "basic_auth" {
  type = object({
    id       = string
    password = string
  })
  default = null
}

variable "log_retention_in_days" {
  type    = number
  default = 1
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
