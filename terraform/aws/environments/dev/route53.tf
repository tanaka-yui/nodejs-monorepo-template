locals {
  domain              = ""
  domain_mail         = "mail.${local.domain}"
  domain_api_origin   = "api-origin.${local.domain}"
}

module "zone_apps" {
  source = "../../modules/route53/zone"
  domain = local.domain
}

module "domain_api_origin" {
  source  = "../../modules/route53/record_alias"
  zone_id = module.zone_apps.zone_id
  domain  = local.domain_api_origin
  alias = {
    evaluate_target_health = false
    name                   = module.alb_api.alb.dns_name
    zone_id                = module.alb_api.alb.zone_id
  }
}

module "domain_frontend" {
  source  = "../../modules/route53/record_alias"
  zone_id = module.zone_apps.zone_id
  domain  = local.domain
  alias = {
    evaluate_target_health = false
    name                   = module.cloudfront_frontend.domain_name
    zone_id                = module.cloudfront_frontend.hosted_zone_id
  }
}
