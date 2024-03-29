locals {
  #configuração do ambiente
  environment  = "dev"
  owners       = "fiap-4soat-g48"
  project_name = "fiap-4soat-g48-tc"
  eks_version  = "1.29"
  component    = "devops"
  env_name     = "${local.project_name}-${local.environment}"

  aws_default_tags = {
    owners      = local.owners
    component   = local.component
    created-by  = "terraform"
    environment = local.environment
  }

  # configuração da VPC
  vpc_params = {
    vpc_cidr               = "10.1.0.0/16"
    enable_nat_gateway     = true
    one_nat_gateway_per_az = true
    single_nat_gateway     = false
    enable_vpn_gateway     = false
    enable_flow_log        = false
  }

  # nome da imagem do container
  container_images = local.project_name

  # configuração do ECR
  ecs_params = {
    container_port   = "8081"
    memory           = "512"
    cpu              = "256"
    desired_capacity = 3
  }
}