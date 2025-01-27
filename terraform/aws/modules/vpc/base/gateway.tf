resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-igw"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.eip_a.id
  subnet_id     = aws_subnet.subnet_public_a.id

  tags = {
    Name = "${var.name}-nat-gateway-a"
  }

  depends_on = [
    aws_eip.eip_a,
    aws_subnet.subnet_public_a
  ]
}

resource "aws_nat_gateway" "nat_gateway_c" {
  allocation_id = aws_eip.eip_c.id
  subnet_id     = aws_subnet.subnet_public_c.id

  tags = {
    Name = "${var.name}-nat-gateway-c"
  }

  depends_on = [
    aws_eip.eip_c,
    aws_subnet.subnet_public_c
  ]
}
