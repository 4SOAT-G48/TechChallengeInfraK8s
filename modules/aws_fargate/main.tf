

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.env_name}-cluster"
  cluster_version = var.eks_version

  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  cluster_enabled_log_types = var.cluster_enabled_log_types

  cluster_addons = {
    kube-proxy = {}
    vpc-cni    = {}
    coredns = {
      configuration_values = jsonencode({
        computeType = "fargate"
      })
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids

  # Fargate profiles use the cluster primary security group so these are not utilized
  create_cluster_security_group = false
  create_node_security_group    = false

  fargate_profile_defaults = {
    iam_role_additional_policies = {
      additional = aws_iam_policy.additional.arn
    }
  }

  fargate_profiles = {
    example = {
      name = "example"
      selectors = [
        {
          namespace = "backend"
          labels = {
            Application = "backend"
          }
        },
        {
          namespace = "app-*"
          labels = {
            Application = "app-wildcard"
          }
        }
      ]

      # Using specific subnets instead of the subnets supplied for the cluster itself
      subnet_ids = [var.subnet_ids[1]]

      tags = {
        Owner = "secondary"
      }
    }
    kube-system = {
      selectors = [
        { namespace = "kube-system" }
      ]
    }
  }

}

################################################################################
# Sub-Module Usage on Existing/Separate Cluster
################################################################################

module "fargate_profile" {
  source = "terraform-aws-modules/eks/aws//modules/fargate-profile"

  name         = "separate-fargate-profile"
  cluster_name = module.eks.cluster_name

  subnet_ids = var.subnet_ids
  selectors = [{
    namespace = "kube-system"
  }]

#  tags = merge(local.tags, { Separate = "fargate-profile" })
}

module "disabled_fargate_profile" {
  source = "terraform-aws-modules/eks/aws//modules/fargate-profile"

  create = false
}

################################################################################
# Supporting Resources
################################################################################
resource "aws_iam_policy" "additional" {
  name = "${var.env_name}-additional"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}