
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

#  region = var.region

  availability_zones = data.aws_availability_zones.available.names

  public_subnets   = [module.subnet_addrs.network_cidr_blocks["public-1"], module.subnet_addrs.network_cidr_blocks["public-2"]]
  private_subnets  = [module.subnet_addrs.network_cidr_blocks["private-1"], module.subnet_addrs.network_cidr_blocks["private-2"]]
  intra_subnets    = [module.subnet_addrs.network_cidr_blocks["intra-1"], module.subnet_addrs.network_cidr_blocks["intra-2"]]
  database_subnets = [module.subnet_addrs.network_cidr_blocks["database-1"], module.subnet_addrs.network_cidr_blocks["database-2"]]

  enable_nat_gateway = local.vpc_params.enable_nat_gateway
  enable_vpn_gateway = local.vpc_params.enable_vpn_gateway

  enable_flow_log = local.vpc_params.enable_flow_log
}

module "ecr" {
  source = "../../modules/aws_ecr"

  container_image = local.container_images
}

module "ecs" {
  source = "../../modules/ecs"

  env_name       = local.env_name
  subnet_ids     = module.vpc.private_subnets
  public_subnets = module.vpc.public_subnets
  vpc_id         = module.vpc.vpc_id


  container_port   = local.ecs_params.container_port
  cpu              = local.ecs_params.cpu
  desired_capacity = local.ecs_params.desired_capacity
  memory           = local.ecs_params.memory
  image_url        = module.ecr.ecr_repository_url
}