locals {
  #informações vinculadas a conta
  //aws_account_id = 654654385771 #labs
  aws_account_id = 471114860739
  region         = "us-east-1"
  profile        = "4soat_g48"
  role_tf        = "tf-admin"
  has_role_tf    = false

  #configuração do ambiente
  environment  = "dev"
  owners       = "4soat-g48"
  project_name = "4soat-g48-tc"
  eks_version  = "1.27"
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

  # configuração EKS
  eks_params = {
    cluster_endpoint_public_access = true
    cluster_enabled_log_types      = ["audit", "api", "authenticator", "controllerManager", "scheduler"]
  }

  eks_managed_node_group_params = {
    default_group = {
      min_size       = 2
      max_size       = 6
      desired_size   = 2
      instance_types = ["t3.micro"]
      capacity_type  = "ON_DEMAND"
      taints = [
        {
          key    = "CriticalAddonsOnly"
          value  = "true"
          effect = "NO_SCHEDULE"
        },
        {
          key    = "CriticalAddonsOnly"
          value  = "true"
          effect = "NO_EXECUTE"
        }
      ]
      max_unavailable_percentage = 50
    }
  }

  eks_aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${local.aws_account_id}:user/arseny"
      username = "arseny"
      groups   = ["system:masters"]
    }
  ]
}