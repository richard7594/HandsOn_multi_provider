output "launch_template" {
  value = aws_launch_template.template.id

}

output "instance_id" {
  value = aws_instance.ec2.id
}