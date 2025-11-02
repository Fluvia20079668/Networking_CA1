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
    bucket         = "my-github-actions-terraform-state"  # Your S3 bucket for state
    key            = "infra/terraform.tfstate"            # Path to state file
    region         = "us-west-2"                          # S3/DynamoDB region
    encrypt        = true                                 # Enable server-side encryption
    use_lockfile   = true                                 # ✅ Supported in Terraform 1.5+ for local/CI
    # Optional: Uncomment if you want DynamoDB-based remote locking
    # dynamodb_table = "my-terraform-lock-table"
  }
}

