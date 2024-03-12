variable "project_name" {
  description = "Nome do projeto para ser usado nos recursos"
  type        = string
}

variable "owners" {
  description = "Nome do proprietário"
  type        = string
}

variable "component" {
  description = "Time que usa o projeto (backend, web, ios, data, devops)"
  type        = string
}

variable "environment" {
  description = "Dev/Prod, usado nos recursos AWS para compor tags e nomes do recuros"
  type        = string
}

variable "vpc_cidr" {
  description = "Bloco CIDR para a VPC"
  type        = string
}

variable "availability_zones" {
  description = "Listas de nomes ou ids de zonas disponiveis na região"
  type        = list(string)
  #default     = ["a", "b"]
}

variable "public_subnets" {
  description = "Lista de subnets publicas dentro da VPC"
  type        = list(string)
  # default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "private_subnets" {
  description = "Lista de subnets privadas dentro da VPC"
  type        = list(string)
  # default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "intra_subnets" {
  description = "Lista de subnets kubernetes control panel dentro da VPC"
  type        = list(string)
}

variable "database_subnets" {
  description = "Lista de subnets para databases dentro da VPC"
  type        = list(string)
}

# VPC Enable NAT Gateway (True or False) 
variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Ativa ou inativa a vpn gateway"
  type        = bool
  default     = true
}

variable "enable_flow_log" {
  description = "Ativa ou desativa os logs de trafego"
  type        = bool
  default     = false
}




# # VPC Single NAT Gateway (True or False)
# variable "single_nat_gateway" {
#   description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
#   type        = bool
#   default     = true
# }



# variable "public_subnets_cidr" {
#   description = "CIDR blocks for the public subnets"
#   type        = list(string)
# }

# # Environment Variable

# # VPC Database Subnets
# variable "database_subnets" {
#   description = "A list of database subnets inside the VPC"
#   type        = list(string)
#   default     = ["10.0.151.0/24", "10.0.152.0/24"]
# }

# # VPC Create Database Subnet Group (True / False)
# variable "create_database_subnet_group" {
#   description = "VPC Create Database Subnet Group, Controls if database subnet group should be created"
#   type        = bool
#   default     = true
# }

# # VPC Create Database Subnet Route Table (True or False)
# variable "create_database_subnet_route_table" {
#   description = "VPC Create Database Subnet Route Table, Controls if separate route table for database should be created"
#   type        = bool
#   default     = true
# }


