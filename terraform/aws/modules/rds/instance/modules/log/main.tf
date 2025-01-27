resource "aws_cloudwatch_log_group" "database_log_group" {
  count = length(var.log_types)

  name              = "/aws/rds/cluster/${var.name}/${var.log_types[count.index]}"
  retention_in_days = var.log_retention_in_days

  tags = {
    Environment = "${var.name}/${var.log_types[count.index]}"
  }
}

resource "aws_cloudwatch_log_group" "database_metrics" {
  name              = "RDSOSMetrics"
  retention_in_days = var.log_retention_in_days

  tags = {
    Environment = "${var.name}/RDSOSMetrics"
  }
}