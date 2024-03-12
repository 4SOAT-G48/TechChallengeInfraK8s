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

/*
variable "min_size" {
  type        = number
  description = ""
}

variable "max_size" {
  type        = number
  description = ""
}

variable "desired_size" {
  type        = number
  description = ""
}

variable "instance_types" {
  type        = list(string)
  description = ""
}

variable "capacity_type" {
  type        = string
  description = ""
}

variable "taints" {
  type        = set(map(string))
  description = ""
}

variable "max_unavailable_percentage" {
  type        = number
  description = ""
}
*/

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

/*
variable "eks_aws_auth_users" {
  description = "IAM Users to be added to the aws-auth ConfigMap, one item in the set() per each IAM User"
  type = set(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}*/
