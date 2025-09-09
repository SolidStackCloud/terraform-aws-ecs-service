resource "aws_cloudwatch_log_group" "main" {
  name = "${var.service_name}-service-logs"

  retention_in_days = var.cloudwatch_retention_days
}


