resource "aws_alb_listener_rule" "main" {
  listener_arn = var.solidstack_vpc_module ? data.aws_ssm_parameter.loadbalancer_listiner[0].value : var.loadbalancer_listiner

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main.arn
  }

  condition {
    host_header {
      values = var.service_url
    }
  }
}