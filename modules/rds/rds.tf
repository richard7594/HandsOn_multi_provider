resource "aws_db_subnet_group" "subnet" {
  name       = "rds_subnet"
  subnet_ids = [var.rds_sub_id1, var.rds_sub_id2]

  tags = {
    Name = "rds_subnet"
  }

}

# Need to create manually kms key to rest encryption db
# data "aws_kms_key" "kms" {

# }

resource "aws_db_instance" "db" {
  instance_class              = "db.t3.micro"
  allocated_storage           = 5
  db_name                     = "wordpress"
  engine                      = "mysql"
  engine_version              = "8.0"
  username                    = "wordpress"
  vpc_security_group_ids      = [var.rds_sg_id]
  db_subnet_group_name        = aws_db_subnet_group.subnet.name
  apply_immediately           = true #
  skip_final_snapshot         = true
  manage_master_user_password = true

}