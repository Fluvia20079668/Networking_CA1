terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  # Backend block is empty here; config is passed during 'terraform init'
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

resource "random_string" "unique" {
  length  = 6
  upper   = false
  special = false
}

# (rest of your resources: VPC, subnets, EKS, ECR, etc.)
