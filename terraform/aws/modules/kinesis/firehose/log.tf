resource "aws_cloudwatch_log_group" "log_group_kinesis" {
  name              = "${var.name}-kinesis"
  retention_in_days = var.log_retention_in_days
}

resource "aws_cloudwatch_log_stream" "log_group_kinesis_log_stream" {
  log_group_name = aws_cloudwatch_log_group.log_group_kinesis.name
  name           = local.log_stream

  depends_on = [aws_cloudwatch_log_group.log_group_kinesis]
}