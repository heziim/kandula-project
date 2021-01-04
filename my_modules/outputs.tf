output "vpc_id" {
    value = aws_vpc.main_vpc.id
}
  
output "private_subnets_ids" {
    value = aws_subnet.private.*.id
}

output "public_subnets_ids" {
    value = aws_subnet.public.*.id
}

#output "internet_gw" {
#    value = aws_internet_gateway.*.id
#}
