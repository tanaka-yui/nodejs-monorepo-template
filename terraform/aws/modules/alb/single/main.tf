resource "aws_alb" "alb" {
  name                       = "${var.name}-alb"
  internal                   = false
  security_groups            = [aws_security_group.alb_security_group.id]
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = var.enable_deletion_protection

  dynamic "access_logs" {
    for_each = var.access_log_bucket != null ? [var.access_log_bucket] : []
    content {
      bucket  = var.access_log_bucket
      prefix  = var.access_log_prefix
      enabled = true
    }
  }

  depends_on = [
    aws_security_group.alb_security_group,
  ]
}

resource "aws_alb_listener" "alb_listener_http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  depends_on = [
    aws_alb.alb,
  ]
}

resource "aws_alb_listener" "alb_listener" {
  count = var.certificate_arn == "" ? 0 : 1

  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "forbidden"
      status_code  = "403"
    }
  }

  depends_on = [
    aws_alb.alb,
  ]
}

resource "aws_alb_target_group" "alb_target_group" {
  name        = var.name
  port        = var.port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    interval            = 30
    path                = var.health_check_path
    port                = var.port
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 4
    matcher             = var.health_check_matcher
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule" {
  listener_arn = var.certificate_arn == "" ? aws_alb_listener.alb_listener_http.arn : aws_alb_listener.alb_listener[0].arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }

  condition {
    path_pattern {
      values = [var.path_pattern]
    }
  }

  dynamic "condition" {
    for_each = var.use_origin_access_key ? [""] : []
    content {
      http_header {
        http_header_name = var.origin_access_key_name
        values           = [random_password.origin_access_key[0].result]
      }
    }
  }

  depends_on = [
    aws_alb_listener.alb_listener,
    aws_alb_target_group.alb_target_group
  ]
}

resource "aws_security_group" "alb_security_group" {
  name   = "${var.name}-alb-security-group"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-alb-security-group"
  }
}

resource "random_password" "origin_access_key" {
  count = var.use_origin_access_key ? 1 : 0

  length      = 40
  special     = false
  min_special = 5
}