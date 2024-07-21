### VPC
resource "aws_vpc" "my-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

   tags = {
    Name = "my-vpc"
   }
}


#### Internet gateway
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my_IGW"
  }  
}


### Data source to fetch available zones
data "aws_availability_zones" "my_zones" {}


### Public Subnet
resource "aws_subnet" "my_pub_subnet" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = var.pub_cidr
  availability_zone = data.aws_availability_zones.my_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "My_pub_subnet"
  }
}


### route table
resource "aws_route_table" "My_rt" {
  vpc_id = aws_vpc.my-vpc.id

  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }

  tags = {
    Name = "my_route_table"
  }
}


### Attach route table to public subnet
resource "aws_route_table_association" "my_rt_associate" {
  subnet_id = aws_subnet.my_pub_subnet.id
  route_table_id = aws_route_table.My_rt.id
}