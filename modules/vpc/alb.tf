
resource "aws_lb" "alb" {
  name                             = "ABL"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.alb_sg.id]
  subnets                          = [aws_subnet.public["az1"].id, aws_subnet.public["az2"].id] # is where we deploy ALB, public subnet and internal = false for internet-facing with internet_gateway
  enable_cross_zone_load_balancing = true

  health_check_logs {
    bucket  = "handson-aws-group"
    enabled = true
    prefix  = "health_check_logs"
  }

  tags = {
    Name = "ABL"
  }

  lifecycle {
    prevent_destroy = false
  }  
}

resource "aws_lb_target_group" "tg" {
  name             = "ec2"
  port             = "80" # 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = aws_vpc.vpc.id
  target_type      = "instance" # this one is responsible for fetch instance on  private subnet and any kind of subnet 

  health_check {
    path                = "/"
    unhealthy_threshold = 6
  }

}

resource "aws_lb_target_group" "kubernetes" {
  name        = "kubernetes"
  port        = "6443" # 80
  protocol    = "HTTPS"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance" # this one is responsible for fetch instance on  private subnet and any kind of subnet 

  health_check {
    path                = "/"
    unhealthy_threshold = 6
    matcher             = "200-499"
  }

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


resource "aws_lb_listener" "kurbenetes" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "6443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kubernetes.arn
  }
}





resource "aws_lb_listener_rule" "rule" {
  listener_arn = aws_lb_listener.wordpress.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition { #I don't know the behaviour of this block , to be assess
    source_ip {
      values = ["0.0.0.0/0"]
    }
  }

}


resource "aws_lb_listener_rule" "rule_kubernetes" {
  listener_arn = aws_lb_listener.wordpress.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kubernetes.arn
  }

  condition {
    source_ip {
      values = ["0.0.0.0/0"]
    }
  }

}


# add my own ec2 instance which don't belong ASG

# resource "aws_lb_target_group_attachment" "tg" {
#   target_group_arn = aws_lb_target_group.tg.arn
#   target_id        = var.instance_id
# }
# resource "aws_lb_target_group_attachment" "kubernetes" {
#   target_group_arn = aws_lb_target_group.kubernetes.arn
#   target_id        = var.instance_id
# }

