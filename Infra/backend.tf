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

  use_lockfile = true  # ✅ Top-level only, not in backend

  backend "s3" {
    bucket  = "my-github-actions-terraform-state"  # Your S3 bucket for state
    key     = "infra/terraform.tfstate"            # Path to state file
    region  = "us-west-2"                          # S3/DynamoDB region
    encrypt = true                                 # Enable server-side encryption
    # Optional: Uncomment for DynamoDB-based remote locking
    # dynamodb_table = "my-terraform-lock-table"
  }
}
