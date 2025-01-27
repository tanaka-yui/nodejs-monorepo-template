module "cloudfront_frontend" {
  source = "../../modules/cloudfront/app"

  env                   = local.env
  name                  = local.name_frontend
  domain                = local.domain
  
  acm_certificate_arn = module.acm-certificate-managed-virginia.acm_certificate.arn

  waf_arn = module.waf_admin.waf_arn

  custom_api_origin = [
    {
      domain_name = local.domain
      origin_id   = module.alb_api.alb.id
      origin_access_key_name = module.alb_api.origin_access_key_name
      origin_access_key = module.alb_api.origin_access_key
    }
  ]

  log_retention_in_days = 30

  providers = {
    aws = aws.virginia
  }
}