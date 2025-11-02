terraform {
  required_version = ">= 1.4.0"

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
    bucket  = "my-github-actions-terraform-state"  # Replace with your S3 bucket
    key     = "infra/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
    # Optional: Uncomment for DynamoDB state locking
    # dynamodb_table = "my-terraform-lock-table"
  }
}
