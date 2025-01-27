resource "aws_cloudwatch_log_subscription_filter" "log_filter" {
  name            = "${var.log_group.name}-filter"
  log_group_name  = var.log_group.name
  filter_pattern  = var.filter_pattern
  destination_arn = var.lambda_function.arn

  depends_on = [
    aws_lambda_permission.lambda_permission
  ]
}

resource "aws_lambda_permission" "lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function.function_name
  principal     = "logs.ap-northeast-1.amazonaws.com"
  // workaround for https://github.com/terraform-providers/terraform-provider-aws/issues/14630
  // in aws provider 3.x 'aws_cloudwatch_log_group.lambda.arn' interpolates to something like 'arn:aws:logs:eu-west-1:000000000000:log-group:/aws/lambda/my-group'
  // but we need 'arn:aws:logs:eu-west-1:000000000000:log-group:/aws/lambda/my-group:*'
  source_arn = length(regexall(":\\*$", var.log_group.arn)) == 1 ? var.log_group.arn : "${var.log_group.arn}:*"
  depends_on = [
    var.lambda_function,
    var.log_group,
  ]
}
