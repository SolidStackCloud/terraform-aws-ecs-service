resource "aws_security_group" "main" {
  name   = "${var.service_name}-security-group"
  vpc_id = var.solidstack_vpc_module ? data.aws_ssm_parameter.vpc[0].value : var.vpc_id
  tags = {
    Name = "${var.service_name}-security-group"
  }
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = var.service_port
  to_port           = var.service_port
  protocol          = "-1"
  cidr_blocks       = [var.solidstack_vpc_module ? data.aws_vpc.vpc[0].cidr_block : var.vpc_cidr]
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  security_group_id = aws_security_group.main.id
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}