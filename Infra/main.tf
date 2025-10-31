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
}

provider "aws" {
  region = "us-east-1"
}

# Generate unique suffix for resources
resource "random_string" "unique" {
  length  = 6
  upper   = false
  special = false
}

# --------- VPC ---------
resource "aws_vpc" "main" {
  cidr_block           = "10.${random_string.unique.id}.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tf-vpc-${random_string.unique.id}"
  }
}

# --------- IAM Role ---------
resource "aws_iam_role" "eks_cluster_role" {
  name = "terraform-eks-cluster-role-${random_string.unique.id}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

# --------- ECR Repository ---------
resource "aws_ecr_repository" "app" {
  name = "my-simple-app-${random_string.unique.id}"
}
