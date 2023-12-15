# Test VPC
resource "aws_vpc" "demo-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Public subnets
resource "aws_subnet" "public-1" {
  cidr_block        = var.public_subnet_1_cidr
  vpc_id            = aws_vpc.demo-vpc.id
  availability_zone = var.availability_zones[0]
}
resource "aws_subnet" "public-2" {
  cidr_block        = var.public_subnet_2_cidr
  vpc_id            = aws_vpc.demo-vpc.id
  availability_zone = var.availability_zones[1]
}

# Private subnets
resource "aws_subnet" "private-1" {
  cidr_block        = var.private_subnet_1_cidr
  vpc_id            = aws_vpc.demo-vpc.id
  availability_zone = var.availability_zones[0]
}
resource "aws_subnet" "private-2" {
  cidr_block        = var.private_subnet_2_cidr
  vpc_id            = aws_vpc.demo-vpc.id
  availability_zone = var.availability_zones[1]
}

# Route tables for the subnets
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.demo-vpc.id
}
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.demo-vpc.id
}

# Associate the newly created route tables to the subnets
resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-1.id
}
resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-2.id
}
resource "aws_route_table_association" "private-route-1-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-1.id
}
resource "aws_route_table_association" "private-route-2-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-2.id
}

# Elastic IP
resource "aws_eip" "elastic-ip-for-nat-gw" {
#   domain                    = "vpc"
  associate_with_private_ip = "10.0.0.5"
  depends_on                = [aws_internet_gateway.demo-igw]
}

# NAT gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elastic-ip-for-nat-gw.id
  subnet_id     = aws_subnet.public-1.id
  depends_on    = [aws_eip.elastic-ip-for-nat-gw]
}
resource "aws_route" "nat-gw-route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id
}

# Route the public subnet traffic through the Internet Gateway
resource "aws_route" "public-internet-igw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.demo-igw.id
  destination_cidr_block = "0.0.0.0/0"
}
