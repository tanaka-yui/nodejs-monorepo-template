locals {
  name                      = "${var.env}-${var.name}"
  engine                    = "aurora-mysql"
  engine_mode_provisioned   = "provisioned"
  instance_class_serverless = "db.serverless"
  aurora_family             = "aurora-mysql8.0"
  aurora_engine_version16   = "8.0.mysql_aurora.3.07.1"
  storage_type_optimized    = "aurora-iopt1"
  availability_zones        = ["ap-northeast-1a", "ap-northeast-1c"]
}

resource "random_password" "master_pass" {
  length           = 40
  special          = true
  min_special      = 5
  override_special = "!$%^&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "secrets" {
  name = "${local.name}-db-secrets"
}

resource "aws_secretsmanager_secret_version" "secrets" {
  secret_id = aws_secretsmanager_secret.secrets.id

  secret_string = jsonencode(
    {
      database_name   = aws_rds_cluster.aurora_cluster.database_name
      password        = aws_rds_cluster.aurora_cluster.master_password
      username        = aws_rds_cluster.aurora_cluster.master_username
      engine          = aws_rds_cluster.aurora_cluster.engine
      writer_endpoint = aws_rds_cluster.aurora_cluster.endpoint
      reader_endpoint = aws_rds_cluster.aurora_cluster.reader_endpoint
      port            = aws_rds_cluster.aurora_cluster.port
    }
  )

  depends_on = [
    aws_rds_cluster.aurora_cluster,
  ]
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier              = local.name
  engine                          = local.engine
  engine_mode                     = local.engine_mode_provisioned
  engine_version                  = local.aurora_engine_version16
  database_name                   = var.database.db_name
  port                            = 3306
  master_username                 = var.database.master_username
  master_password                 = random_password.master_pass.result
  backup_retention_period         = var.database.backup_retention_period
  apply_immediately               = var.database.apply_immediately
  preferred_backup_window         = var.database.backup_window
  enabled_cloudwatch_logs_exports = var.database.enabled_cloudwatch_logs_exports
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_parameter_group.name
  db_subnet_group_name            = aws_db_subnet_group.db_subnet_group.name
  storage_type                    = local.storage_type_optimized
  deletion_protection             = true
  storage_encrypted               = true

  serverlessv2_scaling_configuration {
    max_capacity = var.database.max_capacity
    min_capacity = var.database.min_capacity
  }

  vpc_security_group_ids = [
    aws_security_group.db_security_group.id
  ]

  depends_on = [
    aws_db_subnet_group.db_subnet_group,
    aws_rds_cluster_parameter_group.aurora_cluster_parameter_group,
    module.aurora_logs,
  ]
}

resource "aws_rds_cluster_instance" "writer" {
  identifier                   = "${local.name}-writer"
  engine                       = local.engine
  engine_version               = local.aurora_engine_version16
  cluster_identifier           = aws_rds_cluster.aurora_cluster.cluster_identifier
  instance_class               = local.instance_class_serverless
  db_subnet_group_name         = aws_db_subnet_group.db_subnet_group.name
  db_parameter_group_name      = aws_db_parameter_group.aurora_parameter_group.name
  performance_insights_enabled = var.database.performance_insights
  monitoring_interval          = var.database.monitoring_interval
  monitoring_role_arn          = aws_iam_role.rds_monitoring_all_iam_role.arn
  auto_minor_version_upgrade   = false

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [
    aws_rds_cluster.aurora_cluster,
    aws_db_subnet_group.db_subnet_group,
    aws_db_parameter_group.aurora_parameter_group,
  ]
}

resource "aws_rds_cluster_instance" "reader" {
  count                        = var.database.reader_instance_count
  identifier                   = "${local.name}-reader-0${count.index}"
  engine                       = local.engine
  engine_version               = local.aurora_engine_version16
  cluster_identifier           = aws_rds_cluster.aurora_cluster.cluster_identifier
  instance_class               = local.instance_class_serverless
  db_subnet_group_name         = aws_db_subnet_group.db_subnet_group.name
  db_parameter_group_name      = aws_db_parameter_group.aurora_parameter_group.name
  performance_insights_enabled = var.database.performance_insights
  promotion_tier               = var.database.reader_promotion_tier
  monitoring_interval          = var.database.monitoring_interval
  monitoring_role_arn          = aws_iam_role.rds_monitoring_all_iam_role.arn
  availability_zone            = count.index % 2 == 0 ? local.availability_zones[0] : local.availability_zones[1]
  auto_minor_version_upgrade   = false

  depends_on = [
    aws_rds_cluster.aurora_cluster,
    # Create Provisioned instance first so that Provisioned becomes a writer
    aws_rds_cluster_instance.writer,
    aws_db_subnet_group.db_subnet_group,
    aws_db_parameter_group.aurora_parameter_group,
  ]
}

module "aurora_logs" {
  source = "./modules/log"

  name                  = local.name
  log_types             = var.database.enabled_cloudwatch_logs_exports
  log_retention_in_days = var.database.log_retention_in_days
}


resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${local.name}-db-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "db_security_group" {
  name   = "${local.name}-db-security-group"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_group_ids
    content {
      from_port       = 3306
      to_port         = 3306
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  dynamic "ingress" {
    for_each = var.cidr_blocks
    content {
      from_port   = 3306
      to_port     = 3306
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
}

data "aws_iam_policy_document" "rds-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_monitoring_all_iam_role" {
  name               = "${local.name}-db-role-all-rds-monitor"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.rds-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_all_iam_role_policies_attach" {
  role       = aws_iam_role.rds_monitoring_all_iam_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_parameter_group" "aurora_parameter_group" {
  name   = "${local.name}-parameter-group"
  family = local.aurora_family
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_parameter_group" {
  name   = "${local.name}-cluster-parameter-group"
  family = local.aurora_family

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_filesystem"
    value = "binary"
  }

  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_connection"
    value = "utf8mb4_general_ci"
  }

  parameter {
    name  = "time_zone"
    value = "Asia/Tokyo"
  }
}
