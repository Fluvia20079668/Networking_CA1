terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.20.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# -------------------------
# VPC
# -------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# -------------------------
# Availability Zones
# -------------------------
data "aws_availability_zones" "available" {}

# -------------------------
# Public Subnets
# -------------------------
resource "aws_subnet" "public" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${count.index}"
  }
}

# -------------------------
# Private Subnets
# -------------------------
resource "aws_subnet" "private" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-${count.index}"
  }
}

# -------------------------
# EKS Cluster
# -------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = aws_vpc.main.id

  # Use vpc_subnets instead of deprecated subnet_ids
  vpc_subnets = {
    public  = aws_subnet.public[*].id
    private = aws_subnet.private[*].id
  }

  node_groups = {
    default = {
      desired_capacity = var.node_desired
      max_capacity     = var.node_max
      min_capacity     = var.node_min
      instance_types   = var.node_instance_type
    }
  }

  tags = {
    Environment = "dev"
  }
}

# -------------------------
# Output
# -------------------------
output "cluster_name" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}
