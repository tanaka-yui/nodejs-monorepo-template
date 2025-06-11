output "launch_template_id" {
  value = aws_launch_template.this.id
}

output "cluster_security_group_id" {
  value = aws_security_group.this.id
}
