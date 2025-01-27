resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "A"
  ttl     = var.ttl
  records = var.records
}
