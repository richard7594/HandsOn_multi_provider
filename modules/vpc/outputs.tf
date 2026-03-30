output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "pub_sub_id1" {
  value = aws_subnet.public["az1"].id
}

output "pub_sub_id" {
  value = aws_subnet.public["az2"].id
}

output "pri_sub_id1" {
  value = aws_subnet.private["az1"].id
}
output "pri_sub_id2" {
  value = aws_subnet.private["az2"].id
}

output "rds_sub_id1" {
  value = aws_subnet.rds_private["az1"].id
}
output "rds_sub_id2" {
  value = aws_subnet.rds_private["az2"].id
}



# output "target_group_arn" {
#   value = aws_lb_target_group.tg.arn
# }

output "instance_sg_id" {
  value = aws_security_group.instance_sg.id
}


output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}