locals {
  name                 = "${var.env}-${var.name}"
  engine               = "redis"
  engine_version       = "7.0"
  parameter_group_name = "default.redis7"
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = local.name
  num_cache_nodes      = 1
  engine               = local.engine
  engine_version       = local.engine_version
  node_type            = var.node_type
  parameter_group_name = local.parameter_group_name
  port                 = 6379
  security_group_ids   = [aws_security_group.security_group_redis.id]
  subnet_group_name    = aws_elasticache_subnet_group.elasticache_subnet_group_redis.name
}

resource "aws_elasticache_subnet_group" "elasticache_subnet_group_redis" {
  name       = "${local.name}-redis-subnet"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "security_group_redis" {
  name   = "${local.name}-redis-security-group"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_group_ids
    content {
      from_port       = 6379
      to_port         = 6379
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  dynamic "ingress" {
    for_each = var.cidr_blocks
    content {
      from_port   = 6379
      to_port     = 6379
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name}-redis-security-group"
  }
}
