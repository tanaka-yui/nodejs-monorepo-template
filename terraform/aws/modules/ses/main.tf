resource "aws_ses_domain_identity" "ses" {
  domain = var.root_domain
}

resource "aws_route53_record" "ses_record" {
  zone_id = var.zone_id
  name    = "_amazonses.${var.zone_name}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.ses.verification_token]

  depends_on = [aws_ses_domain_identity.ses]
}

resource "aws_ses_domain_identity_verification" "verification" {
  domain = aws_ses_domain_identity.ses.id

  depends_on = [aws_route53_record.ses_record]
}

resource "aws_ses_domain_dkim" "dkim" {
  domain = var.root_domain
}

resource "aws_route53_record" "dkim_record" {
  count   = 3
  zone_id = var.zone_id
  name    = "${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}._domainkey.${var.zone_name}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]

  depends_on = [
    aws_ses_domain_dkim.dkim,
  ]
}

resource "aws_ses_domain_mail_from" "ses_from" {
  domain           = aws_ses_domain_identity.ses.domain
  mail_from_domain = "${var.sub_domain_prefix}.${aws_ses_domain_identity.ses.domain}"

  depends_on = [aws_ses_domain_identity.ses]
}

resource "aws_route53_record" "ses_domain_mail_from_mx" {
  zone_id = var.zone_id
  name    = aws_ses_domain_mail_from.ses_from.mail_from_domain
  type    = "MX"
  ttl     = "600"
  records = ["10 feedback-smtp.ap-northeast-1.amazonses.com"]

  depends_on = [
    aws_ses_domain_mail_from.ses_from
  ]
}

resource "aws_route53_record" "ses_domain_mail_from_txt" {
  zone_id = var.zone_id
  name    = aws_ses_domain_mail_from.ses_from.mail_from_domain
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com ~all"]

  depends_on = [
    aws_ses_domain_mail_from.ses_from
  ]
}

resource "aws_route53_record" "ses_domain_mail_from_dmarc" {
  zone_id = var.zone_id
  name    = "_dmarc.${var.root_domain}"
  type    = "TXT"
  ttl     = "600"
  records = ["v=DMARC1; p=none;"]
}
