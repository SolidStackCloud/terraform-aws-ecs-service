# Módulo Terraform para Serviço ECS na AWS

Este módulo do Terraform provisiona um serviço completo no Amazon Elastic Container Service (ECS) usando o AWS Fargate.

Ele é projetado para ser flexível, permitindo a integração com um ambiente de VPC existente ou utilizando os recursos criados pelo módulo [SolidStack VPC](https://github.com/seu-usuario/terraform-aws-solidstack-vpc) através do AWS Systems Manager Parameter Store.

## Funcionalidades

- Criação de um serviço ECS com AWS Fargate.
- Suporte para integração com Application Load Balancer (ALB).
- Criação opcional de um repositório Amazon ECR.
- Gerenciamento de IAM Roles e Policies para a execução do serviço e das tarefas.
- Configuração de Security Group para o serviço.
- Criação de um Log Group no CloudWatch para os logs do serviço.

## Exemplo de Uso

```hcl
module "ecs_service" {
  source = "./terraform-aws-eks-thanos-cluster"

  region                  = "us-east-1"
  project_name            = "meu-projeto"
  service_name            = "thanos"
  solidstack_vpc_module   = true # Utiliza os recursos do módulo VPC

  # Configurações do Serviço
  service_port            = 8080
  service_cpu             = "1024"
  service_memory          = "2048"
  desired_task            = 2
  service_url             = ["thanos.meu-dominio.com"]

  # Configurações da Imagem
  enable_ecr              = true # Habilita o ECR. Se false, use 'docker_image'

  # Variáveis de Ambiente (Opcional)
  environment_variables = [
    {
      name  = "DB_HOST",
      value = "db.example.com"
    }
  ]

  # Health Check (Opcional)
  service_healthcheck = {
    path = "/health"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb_listener_rule.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener_rule) | resource |
| [aws_alb_target_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_cloudwatch_log_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecr_repository.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.service_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.task_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_ssm_parameter.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.loadbalancer_listiner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.vpc_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capabilities"></a> [capabilities](#input\_capabilities) | Compatibilidades necessárias para a tarefa. O padrão é 'FARGATE'. | `list(string)` | <pre>[<br>  "FARGATE"<br>]</pre> | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nome do cluster ECS onde o serviço será implantado. Usado apenas se 'solidstack\_vpc\_module' for false. | `string` | `""` | no |
| <a name="input_desired_task"></a> [desired\_task](#input\_desired\_task) | Número de instâncias da tarefa que o serviço deve manter. | `number` | n/a | yes |
| <a name="input_docker_image"></a> [docker\_image](#input\_docker\_image) | URL da imagem Docker a ser usada no contêiner. Usado apenas se 'enable\_ecr' for false. | `string` | `""` | no |
| <a name="input_enable_ecr"></a> [enable\_ecr](#input\_enable\_ecr) | Se true, cria um repositório ECR para a imagem do serviço. | `bool` | `false` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Lista de variáveis de ambiente para o contêiner. Ex: [{name = 'VAR\_NAME', value = 'VAR\_VALUE'}]. | `list(any)` | `[]` | no |
| <a name="input_loadbalancer_listiner"></a> [loadbalancer\_listiner](#input\_loadbalancer\_listiner) | ARN do listener do Application Load Balancer. Usado apenas se 'solidstack\_vpc\_module' for false. | `string` | `""` | no |
| <a name="input_privates_subnets"></a> [privates\_subnets](#input\_privates\_subnets) | Lista de IDs das subnets privadas. Usado apenas se 'solidstack\_vpc\_module' for false. | `list(string)` | `[]` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nome do projeto. Usado para nomear recursos e buscar parâmetros no SSM. | `string` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Lista de IDs das subnets públicas. Usado apenas se 'solidstack\_vpc\_module' for false. | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | Região da AWS onde os recursos serão implantados. | `string` | n/a | yes |
| <a name="input_service_cpu"></a> [service\_cpu](#input\_service\_cpu) | CPU a ser alocada para a tarefa ECS (ex: '1024' para 1 vCPU). | `string` | n/a | yes |
| <a name="input_service_healthcheck"></a> [service\_healthcheck](#input\_service\_healthcheck) | Configurações do health check para o target group. As chaves incluem 'healthy\_threshold', 'unhealthy\_threshold', 'timeout', 'interval', 'matcher', 'path'. | `map(any)` | <pre>{<br>  "healthy_threshold": 3,<br>  "interval": 60,<br>  "matcher": "200-399",<br>  "path": "/",<br>  "timeout": 10,<br>  "unhealthy_threshold": 3<br>}</pre> | no |
| <a name="input_service_memory"></a> [service\_memory](#input\_service\_memory) | Memória a ser alocada para a tarefa ECS em MiB (ex: '2048' para 2GB). | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Nome base para o serviço ECS e recursos associados (ex: task definition, security group). | `string` | n/a | yes |
| <a name="input_service_port"></a> [service\_port](#input\_service\_port) | Porta que o contêiner expõe. | `number` | n/a | yes |
| <a name="input_service_url"></a> [service\_url](#input\_service\_url) | Lista de URLs (host headers) para a regra do listener do ALB. Ex: ['thanos.example.com'] | `list(string)` | n/a | yes |
| <a name="input_solidstack_vpc_module"></a> [solidstack\_vpc\_module](#input\_solidstack\_vpc\_module) | Se true, o módulo usará os recursos (VPC, subnets, etc.) criados pelo módulo VPC da SolidStack, buscando-os no SSM Parameter Store. O 'project\_name' deve ser o mesmo em ambos os módulos. | `bool` | `false` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | Bloco CIDR da VPC. Usado para a regra de entrada do security group. Usado apenas se 'solidstack\_vpc\_module' for false. | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID da VPC onde o serviço será implantado. Usado apenas se 'solidstack\_vpc\_module' for false. | `string` | `""` | no |
