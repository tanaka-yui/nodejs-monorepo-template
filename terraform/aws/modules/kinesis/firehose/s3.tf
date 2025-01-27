locals {
  STORAGE_CLASS_INTELLIGENT_TIERING = "INTELLIGENT_TIERING"
  STORAGE_CLASS_GLACIER             = "GLACIER"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.name}-logs"
}

resource "aws_s3_bucket_lifecycle_configuration" "archive_logs" {
  count = var.log_retention_in_days > 0 ? 1 : 0

  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    id     = "remove_old_files"
    status = "Enabled"

    expiration {
      days = var.log_retention_in_days
    }
  }
}
