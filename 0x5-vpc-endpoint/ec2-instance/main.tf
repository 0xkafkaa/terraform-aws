terraform {
  required_version = ">=0.12"
}

resource "aws_instance" "ec2" {
  tags = {
    Name = var.instance_name
  }
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  security_groups = [aws_security_group.security_group.id]
  user_data = <<EOF
#!/bin/bash
apt update -y
apt install -y apache2
echo "<h1>Hello from Apache!</h1>" > /var/www/html/index.html
sudo systemctl restart apache2
EOF
}
resource "aws_security_group" "security_group" {
  tags = {
    Name = var.security_group_name
  }
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}