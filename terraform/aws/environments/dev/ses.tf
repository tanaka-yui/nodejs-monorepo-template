module "ses" {
  source = "../../modules/ses"

  root_domain       = local.domain_mail
  sub_domain_prefix = "smtp"
  zone_id           = module.zone_mail.zone_id
  zone_name         = module.zone_mail.zone_name
}