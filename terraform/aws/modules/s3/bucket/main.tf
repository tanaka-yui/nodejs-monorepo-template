resource "aws_s3_bucket" "bucket" {
  bucket = var.name
}

resource "aws_s3_bucket_ownership_controls" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }

  depends_on = [aws_s3_bucket.bucket]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  count = var.enable_managed_encryption ? 1 : 0

  bucket = aws_s3_bucket.bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket.bucket]
}

resource "aws_s3_bucket_lifecycle_configuration" "expiration" {
  count = var.expiration_days > 0 ? 1 : 0

  bucket = aws_s3_bucket.bucket.id

  rule {
    id = "${var.name}-expiration-days--lifecycle"

    expiration {
      days = var.expiration_days
    }

    status = "Enabled"
  }
}