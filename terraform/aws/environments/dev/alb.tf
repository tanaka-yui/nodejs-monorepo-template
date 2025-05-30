module "alb_api" {
  source          = "../../modules/alb/single"
  name            = local.name_api
  certificate_arn = module.acm-certificate-managed.acm_certificate.arn
  vpc_id          = module.vpc-standard.vpc_id
  public_subnet_ids = [
    module.vpc-standard.subnet_public_a.id,
    module.vpc-standard.subnet_public_c.id
  ]
  port              = 8080
  health_check_path = "/health"

  access_log_bucket = module.s3_bucket_alb_logs.bucket.bucket
  access_log_prefix = "api"

  use_origin_access_key = true

  depends_on = [
    module.s3_bucket_alb_logs,
    module.s3_bucket_alb_logs_policy,
  ]
}
