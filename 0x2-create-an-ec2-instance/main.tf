provider "aws" {
    access_key = var.access_key
    secret_key = var.secret_access_key
    region = var.region
}

resource "aws_vpc" "vpc" {
    tags = {
        Name = "0x1_vpc_aps1"
    }
    cidr_block = "10.0.0.0/16"

}

resource "aws_subnet" "public_subnet" {
    tags = {
        Name = "0x1_public_subnet_aps1"
    }
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
}

resource "aws_subnet" "private_subnet" {
    tags = {
        Name = "0x1_private_subnet_aps1"
    }
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-south-1b"
}

resource "aws_route_table" "public_route_table" {
    tags = {
        Name = "0x1_public_route_table_aps1"
    }
    vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table_association" public_route_table_to_public_subnet {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_internet_gateway" "internet_gateway" {
  tags = {
    Name = "0x1_internet_gateway_aps1"
  }
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "ig" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table" "private_route_table" {
    tags = {
        Name = "0x1_private_route_table_aps1"
    }
    vpc_id = aws_vpc.vpc.id
}

resource "aws_main_route_table_association" "main" {
  vpc_id = aws_vpc.vpc.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_table_to_private_subnet" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_instance" "ec2" {
  tags = {
    Name = "0x1_ec2_aps1"
  }
  ami = var.ami
  instance_type = var.instance_type
  key_name = "0x1-aps1-keypair"
  subnet_id = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.security_group.id]
}

resource "aws_security_group" "security_group" {
  tags = {
    Name = "0x1_security_group_aps1"
  }
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port = 22
    to_port = 22
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