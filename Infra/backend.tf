terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.15.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  backend "s3" {
    bucket  = "my-github-actions-terraform-state" # Replace with your actual bucket name
    key     = "infra/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
    # dynamodb_table = "my-terraform-lock-table" # optional, for state locking
  }
}

