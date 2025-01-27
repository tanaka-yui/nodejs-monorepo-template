resource "aws_s3_bucket_policy" "alb_log" {
  bucket = var.bucket
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = length(var.prefixes) > 0 ? [for v in var.prefixes : "arn:aws:s3:::${var.bucket}/${v}/AWSLogs/${var.account_id}/*"] : ["arn:aws:s3:::${var.bucket}/AWSLogs/${var.account_id}/*"]

    principals {
      type        = "AWS"
      identifiers = [var.elb_account_id]
    }
  }
}