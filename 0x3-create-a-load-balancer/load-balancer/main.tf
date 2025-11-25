terraform {
  required_version = ">=0.12"
}

resource "aws_lb_target_group" "target_group" {
  name = var.target_group_name
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
}
resource "aws_lb_target_group_attachment" "target_group_attachment" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id = var.instance_id
  port = 80
}
resource "aws_lb" "load_balancer" {
  name = var.load_balancer_name
  internal = false
  load_balancer_type = "application"
  security_groups = [var.security_group_id]
  subnets = [ for subnet in var.subnet_ids : subnet]
}
resource "aws_lb_listener" "load_balancer_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}