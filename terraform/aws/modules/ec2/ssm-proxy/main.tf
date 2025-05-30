locals {
  INSTANCE_NAME = "${var.name}-ssm-proxy"
}

data "aws_ssm_parameter" "ecs_ami_id" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/arm64/recommended/image_id"
}

resource "aws_instance" "proxy" {
  ami                         = var.ami == "" ? data.aws_ssm_parameter.ecs_ami_id.value : var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.proxy.name

  vpc_security_group_ids = [
    aws_security_group.security_group_ssm_proxy.id
  ]

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name          = local.INSTANCE_NAME
    "Patch Group" = local.INSTANCE_NAME
  }

  depends_on = [
    aws_security_group.security_group_ssm_proxy,
    aws_iam_instance_profile.proxy,
  ]
}

resource "aws_security_group" "security_group_ssm_proxy" {
  name   = local.INSTANCE_NAME
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.INSTANCE_NAME
  }
}

resource "aws_iam_role" "proxy" {
  name               = local.INSTANCE_NAME
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_agent_ssm" {
  role       = aws_iam_role.proxy.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"

  depends_on = [aws_iam_role.proxy]
}

resource "aws_iam_instance_profile" "proxy" {
  name = local.INSTANCE_NAME
  role = aws_iam_role.proxy.name

  depends_on = [aws_iam_role.proxy]
}
