resource "aws_alb_target_group" "main" {
  name        = "${var.service_name}-tg"
  port        = var.service_port
  vpc_id      = var.vpc_id
  protocol    = "HTTP"
  target_type = "ip"
  lifecycle {
    create_before_destroy = true
  }

  health_check {
    healthy_threshold   = lookup(var.service_healthcheck, "healthy_threshold", "3")
    unhealthy_threshold = lookup(var.service_healthcheck, "unhealthy_threshold", "3")
    timeout             = lookup(var.service_healthcheck, "timeout", "10")
    interval            = lookup(var.service_healthcheck, "interval", "60")
    matcher             = lookup(var.service_healthcheck, "matcher", "200")
    path                = lookup(var.service_healthcheck, "path", "/")
    port                = var.service_port
  }
}