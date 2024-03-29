output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "intra_subnets" {
  value = module.vpc.intra_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "intra_route_table_ids" {
  value = [module.vpc.intra_route_table_ids]
}

output "private_route_table_ids" {
  value = [module.vpc.private_route_table_ids]
}

output "public_route_table_ids" {
  value = [module.vpc.public_route_table_ids]
}

output "database_route_table_ids" {
  value = [module.vpc.database_route_table_ids]
}

output "vpc_infos" {
  value = module.vpc
}