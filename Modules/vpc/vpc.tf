resource "aws_vpc" "qntVPC" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name    = "qntVPC"
    Project = "QNT s3-cloudfront"
  }
}

resource "aws_internet_gateway" "qntIGW" {
  vpc_id = aws_vpc.qntVPC.id
  tags = {
    Name    = "qntIGW"
    Project = "QNT s3-cloudfront"
  }
}

resource "aws_eip" "qntNatGatewayEIP1" {
  tags = {
    Name    = "qntNatGatewayEIP1"
    Project = "QNT s3-cloudfront"
  }
}
resource "aws_nat_gateway" "qntNatGateway1" {
  allocation_id = aws_eip.qntNatGatewayEIP1.id
  subnet_id     = aws_subnet.qntPublicSubnet1.id
  tags = {
    Name    = "qntNatGateway1"
    Project = "QNT s3-cloudfront"
  }
}
resource "aws_subnet" "qntPublicSubnet1" {
  vpc_id            = aws_vpc.qntVPC.id
  cidr_block        = var.public_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]
  tags = {
    Name    = "qntPublicSubnet1"
    Project = "QNT s3-cloudfront"
  }
}

resource "aws_eip" "qntNatGatewayEIP2" {
  tags = {
    Name    = "qntNatGatewayEIP2"
    Project = "QNT s3-cloudfront"
  }
}
resource "aws_nat_gateway" "qntNatGateway2" {
  allocation_id = aws_eip.qntNatGatewayEIP2.id
  subnet_id     = aws_subnet.qntPublicSubnet1.id
  tags = {
    Name    = "qntNatGateway2"
    Project = "QNT s3-cloudfront"
  }
}
resource "aws_subnet" "qntPublicSubnet2" {
  vpc_id            = aws_vpc.qntVPC.id
  cidr_block        = var.public_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]
  tags = {
    Name    = "qntPublicSubnet2"
    Project = "QNT s3-cloudfront"
  }
}

resource "aws_subnet" "qntPrivateSubnet1" {
  vpc_id            = aws_vpc.qntVPC.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]
  tags = {
    Name    = "qntPrivateSubnet1"
    Project = "QNT s3-cloudfront"
  }
}
resource "aws_subnet" "qntPrivateSubnet2" {
  vpc_id            = aws_vpc.qntVPC.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]
  tags = {
    Name    = "qntPrivateSubnet2"
    Project = "QNT s3-cloudfront"
  }
}

resource "aws_route_table" "qntPublicRT" {
  vpc_id = aws_vpc.qntVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.qntIGW.id
  }
  tags = {
    Name    = "qntPublicRT"
    Project = "QNT s3-cloudfront"
  }
}
resource "aws_route_table" "qntPrivateRT1" {
  vpc_id = aws_vpc.qntVPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.qntNatGateway1.id
  }
  tags = {
    Name    = "qntPrivateRT1"
    Project = "QNT s3-cloudfront"
  }
}
resource "aws_route_table" "qntPrivateRT2" {
  vpc_id = aws_vpc.qntVPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.qntNatGateway2.id
  }
  tags = {
    Name    = "qntPrivateRT2"
    Project = "QNT s3-cloudfront"
  }
}

resource "aws_route_table_association" "qntPublicRTassociation1" {
  subnet_id      = aws_subnet.qntPublicSubnet1.id
  route_table_id = aws_route_table.qntPublicRT.id
}
resource "aws_route_table_association" "qntPublicRTassociation2" {
  subnet_id      = aws_subnet.qntPublicSubnet2.id
  route_table_id = aws_route_table.qntPublicRT.id
}
resource "aws_route_table_association" "qntPrivateRTassociation1" {
  subnet_id      = aws_subnet.qntPrivateSubnet1.id
  route_table_id = aws_route_table.qntPrivateRT1.id
}
resource "aws_route_table_association" "qntPrivateRTassociation2" {
  subnet_id      = aws_subnet.qntPrivateSubnet2.id
  route_table_id = aws_route_table.qntPrivateRT2.id
}