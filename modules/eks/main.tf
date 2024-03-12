data "aws_caller_identity" "current" {}

resource "aws_iam_role" "eks_masters_access_role" {
  name = "${var.env_name}-masters-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })

  inline_policy {
    name = "${var.env_name}-masters-access-policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["eks:DescribeCluster*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

  tags = {
    Name = "${var.env_name}-access-role"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "${var.env_name}-cluster"
  cluster_version = var.eks_version

  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  cluster_enabled_log_types = var.cluster_enabled_log_types

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids

  manage_aws_auth_configmap = true

  eks_managed_node_groups = {
    default = {

      min_size       = var.min_size
      max_size       = var.max_size
      desired_size   = var.desired_size
      instance_types = var.instance_types
      capacity_type  = var.capacity_type

      taints = var.taints

      update_config = {
        max_unavailable_percentage = var.max_unavailable_percentage
      }
    }
  }

  cluster_identity_providers = {
    sts = {
      client_id = "sts.amazonaws.com"
    }
  }

  aws_auth_users = var.eks_aws_auth_users
  aws_auth_roles = [
    {
      rolearn  = aws_iam_role.eks_masters_access_role.arn
      username = aws_iam_role.eks_masters_access_role.arn
      groups   = ["system:masters"]
    }
  ]
}

# resource "aws_eks_addon" "this" {
#   cluster_name    = "${var.env_name}-cluster"

#   resolve_conflicts_on_create = try(each.value.resolve_conflicts, "OVERWRITE")
#   resolve_conflicts_on_update = try(each.value.resolve_conflicts, "OVERWRITE")
# }