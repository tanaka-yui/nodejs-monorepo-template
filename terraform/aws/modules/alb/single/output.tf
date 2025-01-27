output "alb" {
  value = aws_alb.alb
}

output "target_group" {
  value = aws_alb_target_group.alb_target_group
}

output "alb_listener" {
  value = var.certificate_arn == "" ? aws_alb_listener.alb_listener_http : aws_alb_listener.alb_listener[0]
}

output "origin_access_key_name" {
  value = var.use_origin_access_key ? var.origin_access_key_name : ""
}

output "origin_access_key" {
  value = var.use_origin_access_key ? random_password.origin_access_key[0].result : ""
}

output "alb_security_group_id" {
  value = aws_security_group.alb_security_group.id
}
