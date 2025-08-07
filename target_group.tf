resource "aws_alb_target_group" "main" {
  name        = "${var.service_name}-service-tg"
  port        = var.service_port
  vpc_id      = var.solidstack_vpc_module ? data.aws_ssm_parameter.vpc[0].value : var.vpc_id
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    healthy_threshold   = lookup(var.service_healthcheck, "healthy_threshold", "3")
    unhealthy_threshold = lookup(var.service_healthcheck, "unhealthy_threshold", "3")
    timeout             = lookup(var.service_healthcheck, "timeout", "10")
    interval            = lookup(var.service_healthcheck, "interval", "60")
    matcher             = lookup(var.service_healthcheck, "matcher", "200-399")
    path                = lookup(var.service_healthcheck, "path", "/")
    port                = var.service_port
  }

  lifecycle {
    create_before_destroy = false
  }
}