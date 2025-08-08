resource "aws_appautoscaling_target" "main" {
  max_capacity = var.max_task
  min_capacity = var.min_task
  resource_id = "service/${var.solidstack_vpc_module ? data.aws_ssm_parameter.cluster[0].value : var.cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}
