resource "aws_scheduler_schedule" "ecs_task_schedule" {
  name                = "${var.name}-ecs-task-schedule"
  schedule_expression = var.schedule_expression
  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = var.cluster_arn
    role_arn = aws_iam_role.ecs_task.arn

    ecs_parameters {
      task_definition_arn = var.task_definition_arn_without_revision
      launch_type         = "FARGATE"
      network_configuration {
        subnets          = var.subnets
        security_groups  = [aws_security_group.ecs_task.id]
        assign_public_ip = var.assign_public_ip
      }
      task_count = var.task_count
    }
  }

  description = "Schedule for running ECS task"
}

resource "aws_iam_role" "ecs_task" {
  name               = "${var.name}-role"
  assume_role_policy = file("${path.module}/json/assume-role.json")
}

resource "aws_iam_role_policy" "ecs_task" {
  name = "${var.name}-ecs-task-policy"
  role = aws_iam_role.ecs_task.id
  policy = templatefile("${path.module}/json/role-policy.json", {
    s3_certificate_arn                   = var.s3_certificate_arn
    secret_arn                           = var.secret_arn
    task_definition_arn_without_revision = var.task_definition_arn_without_revision
    cluster_arn                          = var.cluster_arn
  })
}

# Task 実行用のセキュリティグループ
resource "aws_security_group" "ecs_task" {
  name   = "${var.name}-ecs-security-group"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ecs-security-group"
  }
}
