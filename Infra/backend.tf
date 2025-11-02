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

  backend "s3" {
    bucket       = "my-github-actions-terraform-state"
    key          = "infra/terraform.tfstate"
    region       = "us-west-2"    # ✅ your S3/DynamoDB region
    use_lockfile = true           # ✅ replaces the deprecated dynamodb_table
    encrypt      = true
  }
}

