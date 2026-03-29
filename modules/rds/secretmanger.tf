#create manually


# resource "aws_secretsmanager_secret" "secret" {
#   name_prefix = "secret/rds_instance"
# }
# resource "aws_secretsmanager_secret_version" "secret" {
#   secret_id = aws_secretsmanager_secret.secret.id
# }