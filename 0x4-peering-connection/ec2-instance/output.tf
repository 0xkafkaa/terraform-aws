output "instance_id" {
  value = aws_instance.ec2.id
}
output "security_group_id" {
  value = aws_security_group.security_group.id
}