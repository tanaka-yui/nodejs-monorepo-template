resource "aws_cloudwatch_log_group" "firelens" {
  name              = "${var.name}-firelens"
  retention_in_days = var.log_retention_in_days

  tags = {
    Environment = var.env
    Application = var.name
  }
}

resource "aws_cloudwatch_log_group" "std" {
  name              = "${var.name}-std"
  retention_in_days = var.log_retention_in_days

  tags = {
    Environment = var.env
    Application = var.name
  }
}

resource "aws_s3_bucket" "archive_logs" {
  bucket = "${var.name}-archive-logs"
}

resource "aws_s3_bucket_ownership_controls" "archive_logs" {
  bucket = aws_s3_bucket.archive_logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "archive_logs" {
  depends_on = [aws_s3_bucket_ownership_controls.archive_logs]

  bucket = aws_s3_bucket.archive_logs.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "archive_logs" {
  bucket                  = aws_s3_bucket.archive_logs.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  depends_on = [aws_s3_bucket.archive_logs]
}

resource "aws_s3_bucket_lifecycle_configuration" "archive_logs" {
  count = var.archive_log_expiration_days > 0 ? 1 : 0

  bucket = aws_s3_bucket.archive_logs.id

  rule {
    id     = "remove_old_files"
    status = "Enabled"

    expiration {
      days = var.archive_log_expiration_days
    }
  }
}