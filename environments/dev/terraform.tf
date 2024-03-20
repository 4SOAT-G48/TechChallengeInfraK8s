terraform {
  backend "s3" {
    bucket  = "terraform-fiap-4soat-g48-acafl"
    key     = "dev/k8s"
    region  = "us-east-1"
    profile = "4soat_g48"
  }
}