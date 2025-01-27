resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name    = var.domain
  records = var.name_servers
  ttl     = 172800
  type    = "NS"
}
