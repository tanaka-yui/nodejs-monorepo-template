resource "aws_cloudfront_origin_request_policy" "backend_cache_header_policy" {
  name = "${var.name}_backend_cache_header_policy"

  cookies_config {
    cookie_behavior = "none"
  }
  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["Host"]
    }
  }
  query_strings_config {
    query_string_behavior = "all"
  }
}