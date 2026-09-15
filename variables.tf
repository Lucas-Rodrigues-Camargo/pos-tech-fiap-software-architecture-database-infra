variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "oficina-mecanica"
}

variable "environment" {
  type    = string
  default = "production"
}

variable "database_name" {
  type    = string
  default = "oficina_mecanica"
}

variable "database_username" {
  type    = string
  default = "oficina_admin"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}
variable "vpc_id" {
  description = "Output vpc_id do repositório kubernetes-infra."
  type        = string
}
variable "vpc_cidr_block" {
  description = "Output vpc_cidr_block do repositório kubernetes-infra."
  type        = string
}
variable "database_subnet_group_name" {
  description = "Output database_subnet_group_name do repositório kubernetes-infra."
  type        = string
}
