output "endpoint" {
  value = aws_db_instance.this.endpoint
}

output "identifier" {
  value = aws_db_instance.this.id
}

output "port" {
  value = aws_db_instance.this.port
}
