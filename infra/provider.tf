terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.22.1"
    }
  }
}

provider "aws" {
  region  = local.aws_region
  profile = local.aws_profile
  default_tags {
    tags = local.tags
  }
}

locals {
  project_name = var.project_name
  aws_region   = var.aws_region
  aws_profile  = var.aws_profile

  tags = {
    project     = local.project_name
    environment = "dev"
    owner       = "warike"
    cost-center = "development"
    terraform   = "true"
  }
}
