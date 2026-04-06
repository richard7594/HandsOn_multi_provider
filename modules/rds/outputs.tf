output "secret_id" {
  value = aws_db_instance.db.master_user_secret[0].secret_arn
}

output "rds_dns_name" {
  value = aws_db_instance.db.endpoint
}

output "db_name" {
  value = aws_db_instance.db.db_name
}