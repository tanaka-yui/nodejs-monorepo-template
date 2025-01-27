resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "A"

  dynamic "alias" {
    for_each = var.alias != null ? [1] : []
    content {
      evaluate_target_health = false
      name                   = var.alias.name
      zone_id                = var.alias.zone_id
    }
  }
}
