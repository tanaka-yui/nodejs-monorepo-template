locals {
  custom_backend_origin_id = "custom-${var.name}-api"
  x_origin_access_key      = "x-origin-access-key"

  // https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html
  cache_policy_caching_optimized = "658327ea-f89d-4fab-a63d-7e88639e58f6" // CachingOptimized
  cache_policy_caching_disabled  = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" // CachingDisabled

  // https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-origin-request-policies.html
  origin_request_policy_all_viewer = "216adef6-5c7f-47e4-b989-5492eafa07d3" // AllViewer

  env_name = var.env

  app_name = "${var.name}-web"

  cloudfront_function_name = "${var.name}-cloudfront-function"
}
