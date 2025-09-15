# Módulo Terraform - ECS Service

Este módulo Terraform cria um serviço ECS completo com todos os recursos necessários para executar uma aplicação containerizada na AWS.

## Recursos Criados

- **ECS Service** e Task Definition
- **Application Load Balancer** Target Group e Listener Rule
- **Security Group** para o serviço
- **IAM Roles** (Task Execution e Task Role)
- **CloudWatch Log Group**
- **Auto Scaling** configurado por CPU e memória
- **ECR Repository** (opcional)
- **Route53 Record** (opcional)
- **EFS Mount** (opcional)

## Uso Básico

```hcl
module "ecs_service" {
  source = "./modules/service"

  # Configurações básicas
  region       = "us-east-1"
  project_name = "meu-projeto"
  
  # Rede
  vpc_id            = "vpc-12345678"
  vpc_cidr          = ["10.0.0.0/16"]
  privates_subnets  = ["subnet-12345678", "subnet-87654321"]
  
  # ECS
  cluster_name = "meu-cluster"
  service_name = "minha-aplicacao"
  service_port = 8080
  
  # Recursos
  service_cpu    = 512
  service_memory = 1024
  desired_task   = 2
  
  # Auto Scaling
  min_task                = 1
  max_task                = 10
  ecs_cpu_utilization     = 70
  ecs_memory_utilization  = 80
  
  # Load Balancer
  loadbalancer_listiner = "arn:aws:elasticloadbalancing:us-east-1:123456789012:listener/app/my-alb/1234567890123456/1234567890123456"
  service_url           = ["app.exemplo.com"]
  
  # Imagem Docker
  docker_image = "nginx:latest"
}
```

## Variáveis Obrigatórias

| Nome | Tipo | Descrição |
|------|------|-----------|
| `region` | string | Região AWS |
| `project_name` | string | Nome do projeto |
| `privates_subnets` | list(string) | IDs das subnets privadas |
| `cluster_name` | string | Nome do cluster ECS |
| `service_name` | string | Nome do serviço |
| `service_port` | number | Porta do container |
| `service_cpu` | number | CPU da task (ex: 512) |
| `service_memory` | number | Memória da task em MiB (ex: 1024) |
| `desired_task` | number | Número de tasks desejadas |
| `vpc_id` | string | ID da VPC |
| `vpc_cidr` | list(string) | CIDR da VPC |
| `loadbalancer_listiner` | string | ARN do listener do ALB |
| `service_url` | list(string) | URLs para o serviço |
| `min_task` | number | Mínimo de tasks |
| `max_task` | number | Máximo de tasks |
| `ecs_cpu_utilization` | number | % CPU para scaling |
| `ecs_memory_utilization` | number | % memória para scaling |

## Variáveis Opcionais

| Nome | Padrão | Descrição |
|------|--------|-----------|
| `enable_ecr` | false | Criar repositório ECR |
| `docker_image` | "" | Imagem Docker (se ECR desabilitado) |
| `environment_variables` | [] | Variáveis de ambiente |
| `capabilities` | ["FARGATE"] | Compatibilidades da task |
| `cloudwatch_retention_days` | 90 | Retenção de logs |
| `route53_anable` | false | Criar registro Route53 |
| `zone_id` | "" | ID da zona Route53 |

## Exemplo com ECR

```hcl
module "ecs_service" {
  source = "./modules/service"
  
  # ... outras configurações ...
  
  enable_ecr = true
  # docker_image não é necessário quando enable_ecr = true
}
```

## Exemplo com EFS

```hcl
module "ecs_service" {
  source = "./modules/service"
  
  # ... outras configurações ...
  
  efs = {
    enabled          = true
    efs_id          = "fs-12345678"
    efs_access_point = "fsap-12345678"
  }
  
  mountPoints = [
    {
      containerPath = "/data"
      readOnly      = false
    }
  ]
}
```

## Health Check Personalizado

```hcl
module "ecs_service" {
  source = "./modules/service"
  
  # ... outras configurações ...
  
  service_healthcheck = {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout            = 5
    interval           = 30
    matcher            = "200"
    path               = "/health"
  }
}
```

## Pré-requisitos

- Cluster ECS existente
- VPC e subnets configuradas
- Application Load Balancer com listener configurado
- Permissões IAM adequadas para criar os recursos
