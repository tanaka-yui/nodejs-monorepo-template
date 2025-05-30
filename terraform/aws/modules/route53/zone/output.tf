output "zone_id" {
  value = aws_route53_zone.zone.zone_id
}

output "zone_name" {
  value = aws_route53_zone.zone.name
}

output "name_servers" {
  value = aws_route53_zone.zone.name_servers
}