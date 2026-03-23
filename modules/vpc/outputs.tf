output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "pri_sub_id" {
  value = aws_subnet.private.id
}

output "pub_sub_id" {
  value = aws_subnet.public.id
}

output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}

output "instance_sg_id" {
  value = aws_security_group.instance_sg.id
}