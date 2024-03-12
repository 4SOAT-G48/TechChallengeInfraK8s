
data "aws_availability_zones" "available" {
  state = "available"
}

module "subnet_addrs" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = local.vpc_params.vpc_cidr
  networks = [
    {
      name     = "public-1"
      new_bits = 4
    },
    {
      name     = "public-2"
      new_bits = 4
    },
    {
      name     = "private-1"
      new_bits = 4
    },
    {
      name     = "private-2"
      new_bits = 4
    },
    {
      name     = "intra-1"
      new_bits = 8
    },
    {
      name     = "intra-2"
      new_bits = 8
    },
    {
      name     = "database-1"
      new_bits = 8
    },
    {
      name     = "database-2"
      new_bits = 8
    },
  ]
}

module "vpc" {
  source = "../../modules/vpc"

  project_name = local.project_name
  environment  = local.environment
  component    = "devops"
  owners       = local.owners
  vpc_cidr     = local.vpc_params.vpc_cidr

  availability_zones = data.aws_availability_zones.available.names

  public_subnets  = [module.subnet_addrs.network_cidr_blocks["public-1"], module.subnet_addrs.network_cidr_blocks["public-2"]]
  private_subnets = [module.subnet_addrs.network_cidr_blocks["private-1"], module.subnet_addrs.network_cidr_blocks["private-2"]]
  intra_subnets   = [module.subnet_addrs.network_cidr_blocks["intra-1"], module.subnet_addrs.network_cidr_blocks["intra-2"]]
  database_subnets   = [module.subnet_addrs.network_cidr_blocks["database-1"], module.subnet_addrs.network_cidr_blocks["database-2"]]

  enable_nat_gateway = local.vpc_params.enable_nat_gateway
  enable_vpn_gateway = local.vpc_params.enable_vpn_gateway

  enable_flow_log = local.vpc_params.enable_flow_log
}


module "eks" {
  source = "../../modules/eks"

  env_name    = local.env_name
  eks_version = local.eks_version

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  cluster_endpoint_public_access = local.eks_params.cluster_endpoint_public_access
  cluster_enabled_log_types      = local.eks_params.cluster_enabled_log_types

  min_size                   = local.eks_managed_node_group_params.default_group.min_size
  max_size                   = local.eks_managed_node_group_params.default_group.max_size
  desired_size               = local.eks_managed_node_group_params.default_group.desired_size
  instance_types             = local.eks_managed_node_group_params.default_group.instance_types
  capacity_type              = local.eks_managed_node_group_params.default_group.capacity_type
  taints                     = local.eks_managed_node_group_params.default_group.taints
  max_unavailable_percentage = local.eks_managed_node_group_params.default_group.max_unavailable_percentage

  eks_aws_auth_users = local.eks_aws_auth_users
}