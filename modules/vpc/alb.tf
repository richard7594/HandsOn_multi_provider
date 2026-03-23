
resource "aws_lb" "alb" {
  name                             = "ABL"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.alb_sg.id]
  subnets                          = [aws_subnet.public.id]
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "ABL"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "ec2"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb_listener" "wordpress" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_listener_rule" "rule" {
  listener_arn = aws_lb_listener.wordpress.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    #Hum
  }

}