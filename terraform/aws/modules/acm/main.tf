resource "aws_acm_certificate" "acm_certificate" {
  domain_name               = "*.${var.domain}"
  subject_alternative_names = [var.domain]
  validation_method         = "DNS"
}

resource "aws_route53_record" "acm_certificate_records" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
  depends_on = [
    aws_acm_certificate.acm_certificate
  ]
}

resource "aws_acm_certificate_validation" "acm_certificate_records_validation" {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_certificate_records : record.fqdn]
  depends_on = [
    aws_route53_record.acm_certificate_records
  ]
}
