resource "aws_vpc" "main_vps" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "main_subnet" {
  vpc_id     = aws_vpc.main_vps.id
  cidr_block = var.subnet_cidr
  availability_zone =  "${var.region}a"  #"eu-central-1a"  # Set your desired availability zone
}

resource "aws_security_group" "sg_default" {
  name        = "sg_default"
  description = "Example security group for VPC"
  vpc_id      = aws_vpc.main_vps.id

  // Define your security group rules here if needed
}

resource "aws_network_acl" "default_acl" {
  vpc_id = aws_vpc.main_vps.id

  // Define your network ACL rules here if needed
}


