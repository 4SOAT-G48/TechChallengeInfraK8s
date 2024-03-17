################################################################################
# VPC Module
################################################################################
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  #  version = "~> 5.1.1"

  name = local.vpc_name
  cidr = var.vpc_cidr

  azs = var.availability_zones

  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  intra_subnets    = var.intra_subnets
  database_subnets = var.database_subnets

  create_igw              = true
  enable_nat_gateway      = var.enable_nat_gateway
  map_public_ip_on_launch = true

  enable_flow_log = var.enable_flow_log
}


################################################################################
# VPC Endpoints Module
################################################################################
module "endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  #  version = "~> 5.1.1"

  vpc_id = module.vpc.vpc_id

  create_security_group = true

  security_group_description = "VPC endpoint security group"
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [module.vpc.vpc_cidr_block]
    }
  }

  endpoints = {
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = flatten([module.vpc.intra_route_table_ids, module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
      tags            = { Name = "${local.vpc_name}-ddb-ep" }
    },
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = flatten([module.vpc.intra_route_table_ids, module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
      tags            = { Name = "${local.vpc_name}-s3-ep" }
    },
    sts = {
      service             = "sts"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "${local.vpc_name}-sts-ep" }
    },
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "${local.vpc_name}-ecr-api-ep" }
    },
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "${local.vpc_name}-ecr-dkr-ep" }
    }
#  ,
#    rds = {
#      service             = "com.amazonaws.${var.region}.rds"
#      service_type        = "Interface"
#      private_dns_enabled = true
#      subnet_ids          = module.vpc.database_subnets
#      route_table_ids     = flatten([module.vpc.database_route_table_ids, module.vpc.private_route_table_ids])
#      tags                = { Name = "${local.vpc_name}-rds-ep" }
#    }
  }
}