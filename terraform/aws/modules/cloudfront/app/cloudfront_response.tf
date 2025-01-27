resource "aws_cloudfront_response_headers_policy" "web_front_assets_security_header_policy" {
  name = "${var.name}_assets_security_header_policy"

  security_headers_config {
    content_type_options {
      override = true
    }
    frame_options {
      frame_option = "SAMEORIGIN"
      override     = true
    }
    referrer_policy {
      referrer_policy = "no-referrer"
      override        = true
    }
    xss_protection {
      mode_block = true
      protection = true
      override   = true
    }
    strict_transport_security {
      access_control_max_age_sec = "31536000"
      include_subdomains         = true
      preload                    = true
      override                   = true
    }
  }

  cors_config {
    access_control_allow_credentials = false
    origin_override                  = false
    access_control_allow_headers {
      items = ["*"]
    }
    access_control_allow_methods {
      items = ["GET", "PUT"]
    }
    access_control_allow_origins {
      items = ["*"]
    }
  }

  custom_headers_config {
    items {
      header   = "x-dns-prefetch-control"
      override = true
      value    = "off"
    }
    items {
      header   = "x-download-options"
      override = true
      value    = "noopen"
    }
  }
}

resource "aws_cloudfront_response_headers_policy" "web_front_security_header_policy" {
  name = "${var.name}_security_header_policy"

  security_headers_config {
    content_type_options {
      override = true
    }
    frame_options {
      frame_option = "SAMEORIGIN"
      override     = true
    }
    referrer_policy {
      referrer_policy = "no-referrer"
      override        = true
    }
    xss_protection {
      mode_block = true
      protection = true
      override   = true
    }
    strict_transport_security {
      access_control_max_age_sec = "31536000"
      include_subdomains         = true
      preload                    = true
      override                   = true
    }
  }

  custom_headers_config {
    items {
      header   = "cache-control"
      override = true
      value    = "no-store, no-cache, must-revalidate, proxy-revalidate"
    }
    items {
      header   = "expect-ct"
      override = true
      value    = "max-age=0"
    }
    items {
      header   = "expires"
      override = true
      value    = "0"
    }
    items {
      header   = "pragma"
      override = true
      value    = "no-cache"
    }
    items {
      header   = "surrogate-control"
      override = true
      value    = "no-store"
    }
    items {
      header   = "x-dns-prefetch-control"
      override = true
      value    = "off"
    }
    items {
      header   = "x-download-options"
      override = true
      value    = "noopen"
    }
  }
}