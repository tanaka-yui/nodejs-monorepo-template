resource "aws_kinesis_firehose_delivery_stream" "firehose_delivery_stream" {
  name        = var.name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.s3_bucket.arn
    buffering_size     = 10
    buffering_interval = 300
    compression_format = "UNCOMPRESSED"
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.log_group_kinesis.name
      log_stream_name = local.log_stream
    }
  }

  depends_on = [
    aws_iam_role.firehose_role,
    aws_s3_bucket.s3_bucket
  ]
}