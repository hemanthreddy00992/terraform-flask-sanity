output "vpc_id" {
  value = aws_vpc.my-vpc.id
}

output "pub_sub_id" {
  value = aws_subnet.my_pub_subnet.id
}

output "igw_id" {
  value = aws_internet_gateway.my-igw.id
}