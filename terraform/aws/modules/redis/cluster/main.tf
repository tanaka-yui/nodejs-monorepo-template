locals {
  name                 = "${var.env}-${var.name}"
  engine               = "redis"
  engine_version       = "7.0"
  parameter_group_name = "default.redis7"
}

resource "aws_elasticache_cluster" "elasticache_cluster" {
  cluster_id           = local.name
  replication_group_id = aws_elasticache_replication_group.elasticache_replication_group_redis.replication_group_id

  depends_on = [aws_elasticache_replication_group.elasticache_replication_group_redis]
}

resource "aws_elasticache_replication_group" "elasticache_replication_group_redis" {
  at_rest_encryption_enabled = false
  auto_minor_version_upgrade = true
  automatic_failover_enabled = true
  engine                     = local.engine
  engine_version             = local.engine_version
  node_type                  = var.node_type
  num_cache_clusters         = var.number_cache_clusters
  parameter_group_name       = local.parameter_group_name
  description                = local.name
  port                       = 6379
  replication_group_id       = local.name
  security_group_ids         = [aws_security_group.security_group_redis.id]
  subnet_group_name          = aws_elasticache_subnet_group.elasticache_subnet_group_redis.name
  transit_encryption_enabled = false

  lifecycle {
    ignore_changes = [
      num_cache_clusters
    ]
  }

  depends_on = [
    aws_elasticache_subnet_group.elasticache_subnet_group_redis,
    aws_security_group.security_group_redis
  ]
}

resource "aws_elasticache_subnet_group" "elasticache_subnet_group_redis" {
  name       = "${local.name}-redis-subnet"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "security_group_redis" {
  name   = "${local.name}-redis-security-group"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
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
