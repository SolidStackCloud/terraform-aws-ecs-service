resource "aws_ecs_task_definition" "main" {
  family                   = "${var.service_name}-task-definition"
  requires_compatibilities = var.capabilities
  network_mode             = "awsvpc"
  cpu                      = var.service_cpu
  memory                   = var.service_memory
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.service_role.arn
  container_definitions = jsonencode([
    {
      name      = "${var.service_name}-container"
      image     = var.enable_ecr ? "${aws_ecr_repository.main[0].repository_url}:latest" : var.docker_image
      cpu       = var.service_cpu
      memory    = var.service_memory
      essential = true
      portMappings = [
        {
          containerPort = var.service_port
          hostPort      = var.service_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.main.id
          awslogs-region        = var.region
          awslogs-stream-prefix = "${var.service_name}-service-logs"
        }
      }
      environment = var.environment_variables
    }
  ])
  
  tags = {
    Name = "${var.service_name}-task-definition"
  }
}