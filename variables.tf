variable "region" {
  description = "Region utilizada para implantar os recursos na AWS"
  type = string
}

variable "project_name" {
  description = "Nome dado ao projeto que será executado. Esse nome será utilizando na construção do name de alguns recursos."
  type = string
}

variable "solidstack_vpc_module" {
  description = "Essa condicional é utilizada para especificar se será utilizado o modulo VPC como base. Para utilizar essa funcionalidade é extremamente importante que na utilização dos dois modulos seja utilizar o mesmo valor para a variável 'project_name' "
  type = bool
}

variable "cluster_name" {
  description = "Essa variável é utilizada se não for utilizado o modulo de VPC da SolidStack Cloud. Tornando esse modulo reutilizado para ambientes já existentes"
  type = string
  default = ""
}

variable "public_subnets" {
  description = "Essa variável é utilizada se não for utilizado o modulo de VPC da SolidStack Cloud. Tornando esse modulo reutilizado para ambientes já existentes"
  type = list(string)
  default = []
}

variable "privates_subnets" {
  description = "Essa variável é utilizada se não for utilizado o modulo de VPC da SolidStack Cloud. Tornando esse modulo reutilizado para ambientes já existentes"
  type = list(string)
  default = []
}


## Variáveis para construção do serviço

variable "service_name" {
  description = "Nome dado ao ECS service."
  type = string
}

variable "service_port" {
  
}

variable "service_cpu" {
  
}

variable "service_memory" {
  
}

variable "service_listiner" {
  
}