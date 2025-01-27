resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "MX"
  ttl     = 300
  records = var.records
}
