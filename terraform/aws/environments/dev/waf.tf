locals {
  allow_ip_addresses = []
}

module "kinesis_waf_api" {
  source = "../../modules/kinesis/firehose"

  account_id                  = local.account_id
  region                      = local.region
  name                        = "aws-waf-logs-${local.name_api}"
  log_retention_in_days       = 1
  archive_log_expiration_days = 30

  providers = {
    aws = aws.virginia
  }
}

module "waf_api" {
  source = "../../modules/waf"

  scope = "CLOUDFRONT"
  name  = local.name_api
  logging = {
    enable              = false
    delivery_stream_arn = module.kinesis_waf_api.delivery_stream_arn
  }

  bot_control_api_key = module.cloudfront_api.api_key

  providers = {
    aws = aws.virginia
  }

  depends_on = [
    module.kinesis_waf_api,
  ]
}
