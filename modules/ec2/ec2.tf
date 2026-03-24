data "aws_ami" "ami" {

  most_recent = true
  owners      = ["136693071363"] # acount which publish debian ami

  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
  }
}

resource "aws_launch_template" "template" {
  name = "template"

  # to be complete
  # block_device_mappings {

  # }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }

  image_id               = data.aws_ami.ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.instance_sg_id]
  user_data              = filebase64("${path.root}/user_data.sh")
}

resource "aws_instance" "ec2" {
  launch_template {
    name    = aws_launch_template.template.name
    version = "$Latest"
  }
  subnet_id = var.subnet_id
}