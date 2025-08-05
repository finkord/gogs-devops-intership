resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project}-rds-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier             = "${var.project}-rds"
  engine                 = "postgres"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  port                   = 5432
  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.this.name
  skip_final_snapshot    = true
  publicly_accessible    = var.publicly_accessible

  monitoring_interval = 60
  monitoring_role_arn = var.rds_monitoring_role_arn

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  tags = {
    Name = "${var.project}-rds"
  }

  lifecycle {
    prevent_destroy = true
  }
}
