module "s3_bucket_alb_logs" {
  source = "../../modules/s3/bucket"

  name                      = "${local.name}-alb-logs"
  expiration_days           = 30
  enable_managed_encryption = true
}

module "s3_bucket_alb_logs_policy" {
  source     = "../../modules/s3/alb_log_policy"
  account_id = local.account_id
  bucket     = module.s3_bucket_alb_logs.bucket.bucket
  prefixes = [
    "api",
  ]

  depends_on = [
    module.s3_bucket_alb_logs
  ]
}
