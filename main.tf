resource "random_password" "database" {
  length           = 32
  special          = true
  override_special = "!#$%&*+-.:=?@_"
}

resource "aws_secretsmanager_secret" "database" {
  name                    = "${var.project_name}/${var.environment}/database"
  recovery_window_in_days = 7
}

resource "aws_security_group" "database" {
  name        = "${var.project_name}-database"
  description = "PostgreSQL access from private workloads in the application VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL inside VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "${var.project_name}-postgres"

  engine         = "postgres"
  engine_version = "16"
  instance_class = var.instance_class
  db_name        = var.database_name
  username       = var.database_username
  password       = random_password.database.result
  port           = 5432

  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp3"
  storage_encrypted     = true

  db_subnet_group_name   = var.database_subnet_group_name
  vpc_security_group_ids = [aws_security_group.database.id]
  publicly_accessible    = false
  multi_az               = false

  backup_retention_period   = 7
  deletion_protection       = true
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.project_name}-final-snapshot"
}

resource "aws_secretsmanager_secret_version" "database" {
  secret_id = aws_secretsmanager_secret.database.id
  secret_string = jsonencode({
    host     = aws_db_instance.postgres.address
    port     = aws_db_instance.postgres.port
    dbname   = var.database_name
    username = var.database_username
    password = random_password.database.result
  })
}

