resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "CNAME"
  ttl     = 300
  records = var.records
}
