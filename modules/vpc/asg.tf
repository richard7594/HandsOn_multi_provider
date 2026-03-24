
locals {
  az = ["eu-west-1a", "eu-west-1b"]
}

resource "aws_autoscaling_group" "asg" {

  vpc_zone_identifier = [aws_subnet.private["az1"].id,aws_subnet.private["az2"].id] #vpc identification
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  launch_template {
    id      = var.launch_template
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "asg" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = aws_lb_target_group.tg.arn
}