module "acm-certificate-managed" {
  source = "../../modules/acm"

  domain  = local.domain
  zone_id = module.zone_apps.zone_id
}

module "acm-certificate-managed-virginia" {
  source = "../../modules/acm"

  domain  = local.domain
  zone_id = module.zone_apps.zone_id

  providers = {
    aws = aws.virginia
  }
}