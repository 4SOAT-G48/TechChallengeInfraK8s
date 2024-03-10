# Local Values in Terraform
locals {
  # create a name like 'atlas-eks-dev-1-27'
  env_name = "${var.project_name}-${var.environment}"
}