resource "aws_vpc" "main_vpc" {
  cidr_block	   = var.cidr_block
  instance_tenancy = "default"
  tags = {
    "kubernetes.io/cluster/kandula_hezi" = "shared"
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    "kubernetes.io/cluster/kandula_hezi" = "shared"
    Name = "main Internet GW"
  }
}


data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  #map_public_ip_on_launch = false
  tags = {
    Name = "PrivateSubnet${count.index}"
    "kubernetes.io/cluster/kandula_hezi" = "shared"
    "kubernetes.io/role/internal-elb"            = "1"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  #map_public_ip_on_launch = false
  tags = {
    Name = "PublicSubnet${count.index}"
    "kubernetes.io/cluster/kandula_hezi" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }
}


resource "aws_eip" "nat" {
  count = length(var.private_subnets)
  vpc = true
  tags = {
    "kubernetes.io/cluster/kandula_hezi" = "shared"
    Name = "eip[count.index]"
  }
}

resource "aws_nat_gateway" "natgw" {
  count =  length(var.private_subnets)
  allocation_id = aws_eip.nat.*.id[count.index]
  subnet_id     = aws_subnet.public.*.id[count.index]
  depends_on = [aws_internet_gateway.igw]
  tags = {
    "kubernetes.io/cluster/kandula_hezi" = "shared"
    Name = "NATgw${count.index}"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "kubernetes.io/cluster/kandula_hezi" = "shared"
  }
}

resource "aws_route_table_association" "public_a" {
  count = 2
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count =2
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.*.id[count.index]
  }
  tags = {
    "kubernetes.io/cluster/kandula_hezi" = "shared"
  }
}

resource "aws_route_table_association" "private_a" {
  count = 2
  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.private.*.id[count.index]
}
