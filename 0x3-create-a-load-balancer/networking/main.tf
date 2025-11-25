terraform {
  required_version = ">=0.12"
}

locals {
  vpc_name = "${var.vpc_name}"
  public_subnet_name = "${var.public_subnet_name}"
  private_subnet_name = "${var.private_subnet_name}"
  public_route_table_name = "${var.public_route_table_name}"
  private_route_table_name = "${var.private_route_table_name}"
  internet_gateway_name = "${var.internet_gateway_name}"
}

resource "aws_vpc" "vpc" {
  tags = {
    Name = "${local.vpc_name}"
  }
  cidr_block = "${var.cidr_block_vpc}"
}
resource "aws_subnet" "public_subnet" {
  tags = {
    Name = "${local.public_subnet_name}"
  }
  vpc_id = aws_vpc.vpc.id
  cidr_block = "${var.cidr_block_public_subnet}"
  availability_zone = "${var.availability_zone_public_subnet}"
}
resource "aws_subnet" "private_subnet" {
  tags = {
    Name = "${local.private_subnet_name}"
  }
  vpc_id = aws_vpc.vpc.id
  cidr_block = "${var.cidr_block_private_subnet}"
  availability_zone = "${var.availability_zone_private_subnet}"
}
resource "aws_route_table" "public_route_table" {
  tags = {
    Name = "${local.public_route_table_name}"
  }
  vpc_id = aws_vpc.vpc.id
}
resource "aws_route" "internet_gateway_route" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.internet_gateway.id
}
resource "aws_route_table_association" "public_route_table_to_public_subnet" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_internet_gateway" "internet_gateway" {
  tags = {
    Name = "${local.internet_gateway_name}"
  }
  vpc_id = aws_vpc.vpc.id
}
resource "aws_route_table" "private_route_table" {
  tags = {
    Name = "${local.private_route_table_name}"
  }
  vpc_id = aws_vpc.vpc.id
}
resource "aws_route_table_association" "private_route_table_to_private_subnet" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}