resource "aws_ecr_repository" "main" {
  count = var.enable_ecr ? 1 : 0
  name  = "${var.service_name}-repository"

  force_delete = true
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.service_name}-repository"
  }
}

