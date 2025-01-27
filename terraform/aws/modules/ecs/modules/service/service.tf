resource "aws_ecs_service" "ecs_service" {
  count = var.enable == true ? 1 : 0

  name                               = var.name
  platform_version                   = var.service.platform_version
  cluster                            = var.cluster.id
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  desired_count                      = var.service.desired_count
  launch_type                        = var.service.launch_type
  task_definition                    = var.task_definition_arn

  dynamic "load_balancer" {
    for_each = var.alb_setting != null ? [""] : []
    content {
      container_name   = var.alb_setting.container_name
      container_port   = var.alb_setting.container_port
      target_group_arn = var.alb_setting.target_group_arn
    }
  }

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [aws_security_group.ecs_security_group[0].id]
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      load_balancer,
    ]
  }

  deployment_controller {
    type = var.deploy_mode
  }

  depends_on = [
    aws_security_group.ecs_security_group[0],
  ]
}
