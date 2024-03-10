
# definiçao do provedor AWS e a região onde serão aplicados os demais comandos
provider "aws" {
  profile = "4soat_g48"
  region  = "us-east-1"
  default_tags {
    tags = local.aws_default_tags
  }

  dynamic "assume_role" {
    for_each = local.has_role_tf ? [1] : []
    content {
      role_arn = "arn:aws:iam::${local.aws_account_id}:role/${local.role_tf}"
    }
  }
}