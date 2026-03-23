resource "aws_lb_target_group_attachment" "tg" {
  target_group_arn = var.target_group_arn
  target_id        = ""
}

data "aws_ami" "ami" {

  most_recent = true
  owners      = ["136693071363"] # aacount which publish debian ami

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
    name = "ec2"
    arn  = aws_iam_instance_profile.ec2.arn
  }

  image_id               = data.aws_ami.ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.instance_sg_id]
  user_data              = filebase64("${path.root}/user_data.sh")
}