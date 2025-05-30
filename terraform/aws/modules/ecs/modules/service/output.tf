output "service_name" {
  value = length(aws_ecs_service.ecs_service) == 1 ? aws_ecs_service.ecs_service[0].name : ""
}

output "security_group_id" {
  value = var.enable ? aws_security_group.ecs_security_group[0].id : ""
}
