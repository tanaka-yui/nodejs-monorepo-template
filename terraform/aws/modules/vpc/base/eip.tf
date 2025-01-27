resource "aws_eip" "eip_a" {
  domain = "vpc"

  tags = {
    Name = "${var.name}-nat-gateway-eip-a"
  }
}

resource "aws_eip" "eip_c" {
  domain = "vpc"

  tags = {
    Name = "${var.name}-nat-gateway-eip-c"
  }
}