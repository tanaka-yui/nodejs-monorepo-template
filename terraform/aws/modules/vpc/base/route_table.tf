resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-rtb-public"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_route_table" "route_table_private_a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-rtb-private-a"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_route" "route_nat_a" {
  route_table_id         = aws_route_table.route_table_private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_a.id

  depends_on = [
    aws_route_table.route_table_private_a,
    aws_nat_gateway.nat_gateway_a,
  ]
}

resource "aws_route_table" "route_table_private_c" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-rtb-private-c"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_route" "route_nat_c" {
  route_table_id         = aws_route_table.route_table_private_c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_c.id

  depends_on = [
    aws_route_table.route_table_private_c,
    aws_nat_gateway.nat_gateway_c,
  ]
}

resource "aws_route" "route_igw" {
  route_table_id         = aws_route_table.route_table_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id

  depends_on = [
    aws_route_table.route_table_public,
    aws_internet_gateway.internet_gateway
  ]
}

resource "aws_main_route_table_association" "main_route_table_association" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.route_table_public.id

  depends_on = [aws_route_table.route_table_public]
}

resource "aws_route_table_association" "route_table_association_public_a" {
  route_table_id = aws_route_table.route_table_public.id
  subnet_id      = aws_subnet.subnet_public_a.id

  depends_on = [aws_route_table.route_table_public]
}

resource "aws_route_table_association" "route_table_association_public_c" {
  route_table_id = aws_route_table.route_table_public.id
  subnet_id      = aws_subnet.subnet_public_c.id

  depends_on = [aws_route_table.route_table_public]
}

resource "aws_route_table_association" "route_table_association_private_a" {
  route_table_id = aws_route_table.route_table_private_a.id
  subnet_id      = aws_subnet.subnet_private_a.id

  depends_on = [aws_route_table.route_table_private_a]
}

resource "aws_route_table_association" "route_table_association_private_c" {
  route_table_id = aws_route_table.route_table_private_c.id
  subnet_id      = aws_subnet.subnet_private_c.id

  depends_on = [aws_route_table.route_table_private_c]
}

resource "aws_route_table_association" "route_table_association_isolated_a" {
  route_table_id = aws_route_table.route_table_private_a.id
  subnet_id      = aws_subnet.subnet_isolated_a.id

  depends_on = [aws_route_table.route_table_private_a]
}

resource "aws_route_table_association" "route_table_association_isolated_c" {
  route_table_id = aws_route_table.route_table_private_c.id
  subnet_id      = aws_subnet.subnet_isolated_c.id

  depends_on = [aws_route_table.route_table_private_c]
}
