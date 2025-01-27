resource "aws_route53_zone" "zone" {
  name          = "${var.domain}."
  force_destroy = false
}
