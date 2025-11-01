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
    bucket         = "my-github-actions-terraform-state"
    key            = "infra/terraform.tfstate"
    region         = "eu-north-1"              # ✅ match your GitHub Actions AWS_REGION
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
