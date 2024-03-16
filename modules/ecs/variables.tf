variable "env_name" {
  type = string
}

variable "image_url" {
  #default = "your-account.dkr.ecr.us-east-1.amazonaws.com/my-app-container:latest"
}

variable "container_port" {
  #default = "3000"
}

variable "memory" {
  #default = "512"
}

variable "cpu" {
  #default = "256"
}

variable "desired_capacity" {
  description = "desired number of running nodes (ex: 3"
  type = number
}

variable "vpc_id" {}

variable "subnet_ids" {
  description = "Lista de subnets privadas dentro da VPC"
  type        = list(string)
}

variable "public_subnets" {
  description = "Lista de subnets privadas dentro da VPC"
  type        = list(string)
}