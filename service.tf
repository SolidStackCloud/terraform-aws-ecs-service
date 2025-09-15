resource "aws_ecs_service" "main" {
  name                               = "${var.service_name}-service"
  cluster                            = var.cluster_name
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = var.desired_task
  launch_type                        = "FARGATE"
  propagate_tags                     = "SERVICE"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  platform_version                   = "LATEST"
  enable_ecs_managed_tags            = true
  enable_execute_command             = true
  availability_zone_rebalancing      = "ENABLED"
  force_delete                       = true
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = var.privates_subnets
    assign_public_ip = false
    security_groups  = [aws_security_group.main.id]
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    container_name   = "${var.service_name}-container"
    container_port   = var.service_port
  }


  lifecycle {
    ignore_changes = [desired_count]
  }

  force_new_deployment = true

  depends_on = [aws_ecs_task_definition.main, aws_iam_role.service_role]


  tags = {
    Name = "${var.service_name}-service"
  }
}

