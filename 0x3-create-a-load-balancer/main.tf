provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}

module "vpc_layer" {
  source = "./networking"
  vpc_name = "0x1-vpc-aps1"
  cidr_block_vpc = "10.0.0.0/16"
  public_subnet_name = "0x1-pub-sn-aps1"
  cidr_block_public_subnet = "10.0.1.0/24"
  availability_zone_public_subnet = "ap-south-1a"
  private_subnet_name = "0x1-pri-sn-aps1"
  cidr_block_private_subnet = "10.0.2.0/24"
  availability_zone_private_subnet = "ap-south-1b"
  public_route_table_name = "0x1-pub-rt-aps1"
  private_route_table_name = "0x1-pri-rt-aps1"
  internet_gateway_name = "0x1-ig-aps1"
}