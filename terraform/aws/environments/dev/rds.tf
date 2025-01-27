module "db" {
  source = "../../modules/rds/instance"
  env    = local.env
  name   = local.name
  vpc_id = module.vpc-standard.vpc_id
  security_group_ids = [
    module.ecs_api.security_group_id,
  ]
  subnet_ids = [
    module.vpc-standard.subnet_isolated_a.id,
    module.vpc-standard.subnet_isolated_c.id,
  ]
  database = {
    db_name                         = local.project_name
    master_username                 = local.project_name
    skip_final_snapshot             = false
    performance_insights            = true
    apply_immediately               = false
    log_retention_in_days           = 7
    backup_retention_period         = 30
    backup_window                   = "11:00-11:30"
    enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
    monitoring_interval             = 60
    reader_instance_count           = 1
    reader_promotion_tier           = 2
    min_capacity                    = 1
    max_capacity                    = 2
  }
}
