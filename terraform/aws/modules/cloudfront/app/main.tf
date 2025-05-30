locals {
  web_front_assets_security_header_policy_id = aws_cloudfront_response_headers_policy.web_front_assets_security_header_policy.id
  web_front_security_header_policy_id        = aws_cloudfront_response_headers_policy.web_front_security_header_policy.id
}

resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  web_acl_id = var.waf_arn

  dynamic "logging_config" {
    for_each = var.enable_normal_logging ? [""] : []
    content {
      include_cookies = true
      bucket          = aws_s3_bucket.cloud_front_normal_log[0].bucket_domain_name
    }
  }

  origin {
    domain_name              = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.s3_bucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  dynamic "origin" {
    for_each = var.custom_api_origin
    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id

      custom_header {
        name  = local.x_origin_access_key
        value = origin.value.origin_access_key
      }

      custom_origin_config {
        http_port              = "80"
        https_port             = "443"
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  dynamic "origin" {
    for_each = var.custom_s3_origin
    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id

      s3_origin_config {
        origin_access_identity = origin.value.cloudfront_access_identity_path
      }
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = "index.html"

  aliases = [
    var.domain
  ]

  ordered_cache_behavior {
    path_pattern               = "/assets/*"
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    viewer_protocol_policy     = "redirect-to-https"
    target_origin_id           = aws_s3_bucket.s3_bucket.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.web_front_assets_security_header_policy.id
    cache_policy_id            = local.cache_policy_caching_optimized
    compress                   = true
  }

  ordered_cache_behavior {
    path_pattern               = "/robots.txt"
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    viewer_protocol_policy     = "redirect-to-https"
    target_origin_id           = aws_s3_bucket.s3_bucket.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.web_front_assets_security_header_policy.id
    cache_policy_id            = local.cache_policy_caching_optimized
    compress                   = true
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.custom_ordered_cache_behavior
    content {
      path_pattern               = ordered_cache_behavior.value.path_pattern
      allowed_methods            = ordered_cache_behavior.value.allowed_methods
      cached_methods             = ordered_cache_behavior.value.cached_methods
      viewer_protocol_policy     = ordered_cache_behavior.value.viewer_protocol_policy
      target_origin_id           = ordered_cache_behavior.value.target_origin_id
      cache_policy_id            = ordered_cache_behavior.value.cache_policy_id == null ? local.cache_policy_caching_disabled : ordered_cache_behavior.value.cache_policy_id
      origin_request_policy_id   = ordered_cache_behavior.value.origin_request_policy_id == null ? local.origin_request_policy_all_viewer : ordered_cache_behavior.value.origin_request_policy_id
      compress                   = ordered_cache_behavior.value.compress == null ? false : ordered_cache_behavior.value.compress
      trusted_key_groups         = ordered_cache_behavior.value.trusted_key_groups == null ? [] : ordered_cache_behavior.value.trusted_key_groups
      response_headers_policy_id = ordered_cache_behavior.value.cache_policy_id == null ? local.web_front_security_header_policy_id : ordered_cache_behavior.value.response_headers_policy_id
    }
  }

  dynamic "default_cache_behavior" {
    for_each = var.basic_auth == null ? [""] : []
    content {
      allowed_methods            = ["GET", "HEAD"]
      cached_methods             = ["GET", "HEAD"]
      viewer_protocol_policy     = "redirect-to-https"
      target_origin_id           = aws_s3_bucket.s3_bucket.id
      response_headers_policy_id = aws_cloudfront_response_headers_policy.web_front_security_header_policy.id
      cache_policy_id            = local.cache_policy_caching_optimized
      compress                   = true

      function_association {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.cloudfront_function_spa_route.arn
      }
    }
  }

  dynamic "default_cache_behavior" {
    for_each = var.basic_auth != null ? [""] : []
    content {
      allowed_methods            = ["GET", "HEAD"]
      cached_methods             = ["GET", "HEAD"]
      viewer_protocol_policy     = "redirect-to-https"
      target_origin_id           = aws_s3_bucket.s3_bucket.id
      response_headers_policy_id = aws_cloudfront_response_headers_policy.web_front_security_header_policy.id
      cache_policy_id            = local.cache_policy_caching_optimized
      compress                   = true

      function_association {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.cloudfront_function_spa_route_basic[0].arn
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.acm_certificate_arn
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  depends_on = [
    aws_s3_bucket.s3_bucket,
    aws_cloudfront_response_headers_policy.web_front_assets_security_header_policy,
    aws_cloudfront_response_headers_policy.web_front_security_header_policy,
    aws_cloudfront_function.cloudfront_function_spa_route,
    aws_cloudfront_function.cloudfront_function_spa_route_basic,
  ]
}
