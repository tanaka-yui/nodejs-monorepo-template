resource "aws_cloudfront_function" "cloudfront_function_spa_route" {
  name    = "${var.name}-spa-route"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = file("${path.module}/files/function/request.js")
}

resource "aws_cloudfront_function" "cloudfront_function_spa_route_basic" {
  count = var.basic_auth != null ? 1 : 0

  name    = "${var.name}-spa-route-basic"
  runtime = "cloudfront-js-1.0"
  publish = true
  code = templatefile("${path.module}/files/function/request-with-basic.js", {
    basic_auth = jsonencode(var.basic_auth)
  })
}

resource "aws_cloudwatch_log_group" "log_group_cloudfront_function_spa_route" {
  name              = "/aws/cloudfront/function/${aws_cloudfront_function.cloudfront_function_spa_route.name}"
  retention_in_days = var.log_retention_in_days
  tags = {
    Environment = local.env_name
    Application = local.cloudfront_function_name
  }
}

resource "aws_cloudwatch_log_group" "log_group_cloudfront_function_spa_route_basic_auth" {
  count = var.basic_auth != null ? 1 : 0

  name              = "/aws/cloudfront/function/${aws_cloudfront_function.cloudfront_function_spa_route_basic[0].name}"
  retention_in_days = var.log_retention_in_days
  tags = {
    Environment = local.env_name
    Application = local.cloudfront_function_name
  }
}