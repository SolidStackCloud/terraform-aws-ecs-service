resource "aws_efs_file_system" "main" {
  creation_token = "${var.service_name}-wordpress-efs"
  performance_mode = "generalPurpose"
  tags = {
    Name = "${var.service_name}-wordpress-efs"
  }
}


resource "aws_security_group" "efs" {
  name = "${var.service_name}-efs-security-group"
  vpc_id = var.solidstack_vpc_module ? data.aws_ssm_parameter.vpc[0].value : var.vpc_id
}

resource "aws_security_group_rule" "efs" {
  type = "ingress"
  from_port = 2049
  to_port = 2049
  protocol = "tcp"
  cidr_blocks = ["${var.solidstack_vpc_module ? data.aws_ssm_parameter.vpc_cidr[0].value : var.vpc_cidr}"]
  security_group_id = aws_security_group.efs.id
}
