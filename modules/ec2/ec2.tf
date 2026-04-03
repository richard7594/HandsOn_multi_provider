
# aws ec2 describe-images      --filters "Name=name,Values=AlmaLinux*"    --query 'Images[*].[ImageId,Name]'   --region eu-west-1



# data "aws_ami" "ami" {

#   most_recent = true
#   owners      = ["136693071363"] # acount which publish debian ami

#   filter {
#     name   = "name"
#     values = ["debian-12-amd64-*"]
#   }
# }




# resource "aws_security_group" "bastion" { # it doesn't work for local i gonna to use instance connect instead , on the bastion, instance connect use ssh also with temporary key 

#   vpc_id = var.vpc_id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = -1
#     cidr_blocks = ["0.0.0.0/0"]

#   }
# }





resource "aws_launch_template" "template" {
  name = "template"

  # to be complete
  # block_device_mappings {

  # }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }

  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.instance_sg_id] # remove bastion sg
  user_data              = filebase64("${path.module}/user_data.sh")
}

# resource "aws_instance" "ec2" {
#   launch_template {
#     name    = aws_launch_template.template.name
#     version = "$Latest"
#   }
#   subnet_id                   = var.subnet_id
#   #user_data_replace_on_change = true # where we can put this attribute on ASG
# }



#Bastion need for debug

# resource "aws_instance" "bastion" {

#   launch_template {
#     name    = aws_launch_template.template.name
#     version = "$Latest"
#   }
#   subnet_id = var.pub_sub_id

#   tags = {
#     Name = "bastion"
#   }


#   user_data_replace_on_change = true # very useful 
# }