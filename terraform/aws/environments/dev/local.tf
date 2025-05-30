locals {
  env             = "dev"
  account_id      = ""
  region          = "ap-northeast-1"
  region_virginia = "us-east-1"

  project_name      = "apps"
  name              = "${local.env}-${local.project_name}"
  name_api          = "${local.name}-api"
  name_frontend     = "${local.name}-frontend"
  name_fluent_bit   = "${local.name}-fluent-bit"
}
