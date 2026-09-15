output "database_endpoint" { value = aws_db_instance.postgres.address }
output "database_port" { value = aws_db_instance.postgres.port }
output "database_secret_arn" { value = aws_secretsmanager_secret.database.arn }
output "database_security_group_id" { value = aws_security_group.database.id }

