resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.name
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = "awsvpc"
  requires_compatibilities = var.launch_type
  execution_role_arn       = var.task_execution_role.arn
  task_role_arn            = var.task_role == null ? null : var.task_role.arn
  container_definitions    = var.container_definitions

  dynamic "volume" {
    for_each = var.efs_volume
    content {
      name = volume.value.name
      efs_volume_configuration {
        file_system_id = volume.value.file_system_id
        root_directory = volume.value.root_directory
      }
    }
  }
}