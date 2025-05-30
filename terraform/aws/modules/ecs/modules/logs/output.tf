output "log_group_firelens" {
  value = aws_cloudwatch_log_group.firelens
}

output "log_group_std" {
  value = aws_cloudwatch_log_group.std
}

output "archive_logs_bucket" {
  value = aws_s3_bucket.archive_logs
}