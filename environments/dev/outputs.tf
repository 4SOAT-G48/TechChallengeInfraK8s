output "env_name" {
  value = local.env_name
}

output "vpc_cidr" {
  value = local.vpc_params.vpc_cidr
}

output "vpc_public_subnets" {
  value = [module.subnet_addrs.network_cidr_blocks["public-1"], module.subnet_addrs.network_cidr_blocks["public-2"]]
}

output "vpc_private_subnets" {
  value = [module.subnet_addrs.network_cidr_blocks["private-1"], module.subnet_addrs.network_cidr_blocks["private-2"]]
}

output "vpc_intra_subnets" {
  value = [module.subnet_addrs.network_cidr_blocks["intra-1"], module.subnet_addrs.network_cidr_blocks["intra-2"]]
}

output "vpc_database_subnets" {
  value = [module.subnet_addrs.network_cidr_blocks["database-1"], module.subnet_addrs.network_cidr_blocks["database-2"]]
}

output "vpc_infos" {
  value = module.vpc
}

output "ecs" {
  value = module.ecs
}

output "ecr" {
  value = module.ecr
}