resource "aws_security_group" "ecs_security_group" {
  count = var.enable == true ? 1 : 0

  name   = "${var.name}-ecs-security-group"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ecs-security-group"
  }
}

resource "aws_security_group_rule" "ecs_security_group_rule" {
  count = var.source_security_group_id != null && var.enable == true ? 1 : 0

  type                     = "ingress"
  to_port                  = var.service.container_port
  protocol                 = "tcp"
  source_security_group_id = var.source_security_group_id
  from_port                = var.service.container_port
  security_group_id        = aws_security_group.ecs_security_group[0].id
}
