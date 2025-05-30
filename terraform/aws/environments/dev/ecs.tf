locals {
  log_stream_name = "ecs-log"

  FLUENT_BIT_S3_TOTAL_FILE_SIZE = "50M"
  FLUENT_BIT_S3_UPLOAD_TIMEOUT  = "5m"

  FLUENT_BIT_CONF      = "fluent-bit-custom.conf"
  FLUENT_BIT_CONF_NODE = "node_fluent-bit_to_s3.conf"
}

module "ecs_cluster" {
  source = "../../modules/ecs/modules/cluster"

  name = "${local.name}-cluster"
}

module "ecs_api" {
  source     = "../../modules/ecs/modules/service"
  name       = local.name_api
  account_id = local.account_id
  region     = local.region
  alb_setting = {
    container_name   = local.name_api
    container_port   = 8080
    target_group_arn = module.alb_api.target_group.arn
  }
  cluster                  = module.ecs_cluster.cluster
  repository               = module.ecr_api.repository
  vpc_id                   = module.vpc-standard.vpc_id
  source_security_group_id = module.alb_api.alb_security_group_id
  private_subnet_ids = [
    module.vpc-standard.subnet_private_a.id,
    module.vpc-standard.subnet_private_c.id
  ]
  task_definition_arn = module.ecs_api_task_definition.task_definition.arn
  service = {
    container_port   = 8080
    desired_count    = 1
    launch_type      = "FARGATE"
    platform_version = "1.4.0"
  }
}

module "ecs_api_logs" {
  source = "../../modules/ecs/modules/logs"

  env                         = local.env
  name                        = local.name_api
  archive_log_expiration_days = 30
}

module "ecs_api_task_definition" {
  source = "../../modules/ecs/modules/task_definition"

  name   = local.name_api
  cpu    = 1024
  memory = 2048
  container_definitions = templatefile("${path.module}/../../modules/ecs/templates/task_definition/api-task-definition.json", {
    name                      = local.name_api
    region                    = local.region
    account_id                = local.account_id
    container_port            = 8080
    repository_url_app        = module.ecr_api.repository.repository_url
    repository_url_fluent_bit = module.ecr_fluent_bit.repository.repository_url
    repository_url_proxy      = module.ecr_nginx.repository.repository_url
    firelens_log_group        = module.ecs_api_logs.log_group_firelens.name
    bucket                    = module.ecs_api_logs.archive_logs_bucket.bucket
    app_log_group_name        = module.ecs_api_logs.log_group_std.name
    total_file_size           = local.FLUENT_BIT_S3_TOTAL_FILE_SIZE
    upload_timeout            = local.FLUENT_BIT_S3_UPLOAD_TIMEOUT
    fluent_bit_conf           = local.FLUENT_BIT_CONF
    key_prefix                = local.name_api
    secret_arn                = module.db.secrets.arn
    redis_host                = module.redis.address
    redis_port                = module.redis.port
  })
  task_execution_role = module.ecs_api_role.execution_role
  task_role           = module.ecs_api_role.task_role
}

module "ecs_api_role" {
  source = "../../modules/ecs/modules/role"

  name = local.name_api
  execution_role_policy = templatefile("${path.module}/../../modules/ecs/templates/role/execution-role-policy.json", {
    account_id = local.account_id
    region     = local.region
  })
  task_role_policy = templatefile("${path.module}/../../modules/ecs/templates/role/api-task-role-policy.json", {
    s3_log_arn             = module.ecs_api_logs.archive_logs_bucket.arn
  })
}
