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
module "ec2" {
  source = "./ec2-instance"
  instance_name = "0x1-ec2-aps1"
  instance_type = "t2.nano"
  ami_id = "ami-02b8269d5e85954ef"
  key_name = "vpc-test-ap-south-1-ec2-ssh-keys"
  security_group_name = "0x1-sg-aps1"
  vpc_id = module.vpc_layer.vpc_id
  subnet_id = module.vpc_layer.subnet_ids.public_id
}
module "load_balancer" {
  source = "./load-balancer"
  target_group_name = "0x1-tg-aps1"
  vpc_id = module.vpc_layer.vpc_id
  instance_id = module.ec2.instance_id
  load_balancer_name = "0x1-lb-aps1"
  security_group_id = module.ec2.security_group_id
  subnet_ids = module.vpc_layer.subnet_ids
}