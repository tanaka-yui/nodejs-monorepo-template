variable "bucket" {
  type = string
}

variable "prefixes" {
  type    = list(string)
  default = []
}

variable "account_id" {
  type = string
}

variable "elb_account_id" {
  type    = string
  default = "582318560864" // アジアパシフィック (東京) リージョンのアカウントID
}
