resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = var.name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = local.app_name
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced" // disable acl
  }

  depends_on = [aws_s3_bucket.s3_bucket]
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.s3_main_policy.json
}

data "aws_iam_policy_document" "s3_main_policy" {
  # CloudFront Distribution からのアクセスのみ許可
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_bucket.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.cloudfront_distribution.arn]
    }
  }
}

resource "aws_s3_bucket" "cloud_front_normal_log" {
  count = var.enable_normal_logging ? 1 : 0

  bucket = "${local.app_name}-cf-log"
}

resource "aws_s3_bucket_public_access_block" "cloud_front_normal_log_private_block" {
  count = var.enable_normal_logging ? 1 : 0

  bucket                  = aws_s3_bucket.cloud_front_normal_log[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket.cloud_front_normal_log[0]]
}