resource "aws_cloudwatch_log_group" "main" {
  name = "${var.service_name}-service-logs"

  retention_in_days = 90
}