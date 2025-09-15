variable "region" {
  description = "Região da AWS onde os recursos serão implantados."
  type        = string
}

variable "project_name" {
  description = "Nome do projeto. Usado para nomear recursos e buscar parâmetros no SSM."
  type        = string
}

variable "public_subnets" {
  description = "Lista de IDs das subnets públicas. Usado apenas se 'solidstack_vpc_module' for false."
  type        = list(string)
  default     = []
}

variable "privates_subnets" {
  description = "Lista de IDs das subnets privadas. Usado apenas se 'solidstack_vpc_module' for false."
  type        = list(string)
}

## Variáveis para construção do serviço ECS
variable "cluster_name" {
  description = "Nome do cluster ECS onde o serviço será implantado. Usado apenas se 'solidstack_vpc_module' for false."
  type        = string
}

variable "service_name" {
  description = "Nome base para o serviço ECS e recursos associados (ex: task definition, security group)."
  type        = string
}

variable "service_port" {
  description = "Porta que o contêiner expõe."
  type        = number
}

variable "service_cpu" {
  description = "CPU a ser alocada para a tarefa ECS (ex: '1024' para 1 vCPU)."
  type        = number
}

variable "service_memory" {
  description = "Memória a ser alocada para a tarefa ECS em MiB (ex: '2048' para 2GB)."
  type        = number
}

variable "enable_ecr" {
  description = "Se true, cria um repositório ECR para a imagem do serviço."
  type        = bool
  default     = false
}

variable "docker_image" {
  description = "URL da imagem Docker a ser usada no contêiner. Usado apenas se 'enable_ecr' for false."
  type        = string
  default     = ""
}

variable "environment_variables" {
  description = "Lista de variáveis de ambiente para o contêiner. Ex: [{name = 'VAR_NAME', value = 'VAR_VALUE'}]."
  type        = list(map(any))
  default     = []
}

variable "capabilities" {
  description = "Compatibilidades necessárias para a tarefa. O padrão é 'FARGATE'."
  type        = list(string)
  default     = ["FARGATE"]
}

variable "desired_task" {
  description = "Número de instâncias da tarefa que o serviço deve manter."
  type        = number
}

variable "vpc_id" {
  description = "ID da VPC onde o serviço será implantado. Usado apenas se 'solidstack_vpc_module' for false."
  type        = string

}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC. Usado para a regra de entrada do security group. Usado apenas se 'solidstack_vpc_module' for false."
  type        = list(string)
}

variable "service_healthcheck" {
  description = "Configurações do health check para o target group. As chaves incluem 'healthy_threshold', 'unhealthy_threshold', 'timeout', 'interval', 'matcher', 'path'."
  type = object(
    {
      healthy_threshold   = number
      unhealthy_threshold = number
      timeout             = number
      interval            = number
      matcher             = string
      path                = string
    }
  )
  default = {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 10
    interval            = 60
    matcher             = "200-399"
    path                = "/"
  }
}

variable "loadbalancer_listiner" {
  description = "ARN do listener do Application Load Balancer. Usado apenas se 'solidstack_vpc_module' for false."
  type        = string
}

variable "service_url" {
  description = "Lista de URLs (host headers) para a regra do listener do ALB. Ex: ['thanos.example.com']"
  type        = list(string)
}

variable "min_task" {
  description = "Quantidade mínima de tasks desejadas"
  type        = number
}

variable "max_task" {
  description = "Quantidade máxima de tasks desejadas"
  type        = number
}

variable "ecs_cpu_utilization" {
  description = "Percentual de CPU especificado para scaling do service."
  type        = number
}

variable "ecs_memory_utilization" {
  description = "Percentual de memória especificado para scaling do service."
  type        = number
}

variable "cloudwatch_retention_days" {
  description = "Valor para configurar a quantidade em dias de retenção de logs no cloudwatch"
  type        = number
  default     = 90
}

variable "task_execution_policy_actions" {
  description = "Lista de permissões para task execution role"
  type        = list(string)
  default = [
    "ecr:GetAuthorizationToken",
    "ecr:BatchCheckLayerAvailability",
    "ecr:GetDownloadUrlForLayer",
    "ecr:BatchGetImage",
    "logs:CreateLogStream",
    "logs:PutLogEvents"
  ]
}
## Route53

variable "route53_anable" {
  description = "Se true, cria um registro Route53 para o serviço."
  type        = bool
  default     = false
}

variable "zone_id" {
  description = "Especificar o Route53 Hosted zone ID"
  type        = string
  default     = ""
}

variable "efs" {
  description = "Habilitar e configurar o EFS"
  type = object({
    enabled = bool
    efs_id = string
    root_directory = optional(string)
    efs_access_point = string
  })
  default = {
    enabled = false
    efs_id = ""
    root_directory = ""
    efs_access_point = ""
  }
}

variable "mountPoints" {
  type = list(object({
    containerPath = string
    readOnly = optional(bool)
  }))
  default = []
}
