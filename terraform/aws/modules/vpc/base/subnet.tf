resource "aws_subnet" "subnet_public_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidr.public_a
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-a"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_subnet" "subnet_public_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidr.public_c
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-c"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_subnet" "subnet_private_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr.private_a
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.name}-private-a"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_subnet" "subnet_private_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr.private_c
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${var.name}-private-c"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_subnet" "subnet_isolated_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr.isolated_a
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.name}-isolated-a"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_subnet" "subnet_isolated_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr.isolated_c
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${var.name}-isolated-c"
  }

  depends_on = [aws_vpc.vpc]
}
