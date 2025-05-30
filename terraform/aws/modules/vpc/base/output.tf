output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_public_a" {
  value = aws_subnet.subnet_public_a
}

output "subnet_public_c" {
  value = aws_subnet.subnet_public_c
}

output "subnet_private_a" {
  value = aws_subnet.subnet_private_a
}

output "subnet_private_c" {
  value = aws_subnet.subnet_private_c
}

output "subnet_isolated_a" {
  value = aws_subnet.subnet_isolated_a
}

output "subnet_isolated_c" {
  value = aws_subnet.subnet_isolated_c
}

output "route_table_private_a" {
  value = aws_route_table.route_table_private_a.id
}

output "route_table_private_c" {
  value = aws_route_table.route_table_private_c.id
}
