output "secrets" {
  value = aws_secretsmanager_secret.secrets
}

output "cluster" {
  value = aws_rds_cluster.aurora_cluster
}

output "reader_instance_identities" {
  value = aws_rds_cluster_instance.reader[*].identifier
}