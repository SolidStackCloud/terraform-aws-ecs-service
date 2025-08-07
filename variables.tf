variable "region" {
  description = "Region utilizada para implantar os recursos na AWS"
  type        = string
}

variable "project_name" {
  description = "Nome dado ao projeto que será executado. Esse nome será utilizando na construção do name de alguns recursos."
  type        = string
}

variable "solidstack_vpc_module" {
  description = "Essa condicional é utilizada para especificar se será utilizado o modulo VPC como base. Para utilizar essa funcionalidade é extremamente importante que na utilização dos dois modulos seja utilizar o mesmo valor para a variável 'project_name' "
  type        = bool
}


variable "public_subnets" {
  description = "Essa variável é utilizada se não for utilizado o modulo de VPC da SolidStack Cloud. Tornando esse modulo reutilizado para ambientes já existentes"
  type        = list(string)
  default     = []
}

variable "privates_subnets" {
  description = "Essa variável é utilizada se não for utilizado o modulo de VPC da SolidStack Cloud. Tornando esse modulo reutilizado para ambientes já existentes"
  type        = list(string)
  default     = []
}


## Variáveis para construção do serviço
variable "cluster_name" {
  description = "Essa variável é utilizada se não for utilizado o modulo de VPC da SolidStack Cloud. Tornando esse modulo reutilizado para ambientes já existentes"
  type        = string
  default     = ""
}

variable "service_name" {
  description = "Nome dado ao ECS service."
  type        = string
}

variable "service_port" {

}

variable "service_cpu" {

}

variable "service_memory" {

}

variable "enable_ecr" {

  default = false
}
variable "docker_image" {
  type    = string
  default = ""
}

variable "environment_variables" {
  type    = list(any)
  default = []
}

variable "capabilities" {
  type    = list(string)
  default = ["FARGATE"]
}

variable "target_group_arn" {
  type    = string
  default = ""
}

variable "desired_task" {
  type = number
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "vpc_cidr" {
  type    = string
  default = ""
}

variable "service_healthcheck" {
  type = map(any)
  default = {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timout              = 10
    interval            = 60
    matcher             = "200-399"
    path                = "/"
  }
}

variable "loadbalancer_listiner" {
  type    = string
  default = ""
}

variable "service_url" {
  type = list
}