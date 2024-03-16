variable "env_name" {
  type = string
}

variable "eks_version" {
  type        = string
  description = "Versão do EKS"
}

variable "cluster_endpoint_public_access" {
  type        = bool
  description = "description"
}

variable "cluster_enabled_log_types" {
  type        = list(string)
  description = "description"
}

variable "vpc_id" {}

variable "subnet_ids" {
  description = "Lista de subnets privadas dentro da VPC"
  type        = list(string)
  # default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "control_plane_subnet_ids" {
  description = "Lista de subnets kubernetes control panel dentro da VPC"
  type        = list(string)
}

variable "public_subnets" {
  description = "Lista de subnets privadas dentro da VPC"
  type        = list(string)
}
