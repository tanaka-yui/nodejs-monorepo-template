resource "aws_autoscaling_group" "this" {
  count = var.auto_scaling != null ? 1 : 0

  name                      = var.cluster_name
  max_size                  = var.auto_scaling.max_size
  min_size                  = var.auto_scaling.min_size
  health_check_grace_period = 0
  health_check_type         = "EC2"
  desired_capacity          = var.auto_scaling.desired_capacity
  vpc_zone_identifier       = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    # ECSにスケーリングをお願いするために必要なタグ
    # https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/cluster-auto-scaling.html#update-ecs-resources-cas
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [
      desired_capacity,
    ]
  }

  depends_on = [
    aws_launch_template.this
  ]
}

resource "aws_ecs_capacity_provider" "this" {
  count = var.auto_scaling != null ? 1 : 0

  name = var.cluster_name

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.this[0].arn
    managed_scaling {
      maximum_scaling_step_size = var.capacity_provider.maximum_scaling_step_size
      minimum_scaling_step_size = var.capacity_provider.minimum_scaling_step_size
      status                    = "ENABLED"
      target_capacity           = var.capacity_provider.target_capacity
    }
  }

  depends_on = [aws_autoscaling_group.this]
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  count = var.auto_scaling != null ? 1 : 0

  cluster_name = var.cluster_name

  capacity_providers = [aws_ecs_capacity_provider.this[0].name]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 1
    capacity_provider = aws_ecs_capacity_provider.this[0].name
  }

  depends_on = [aws_ecs_capacity_provider.this]
}
