terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

####################################################
# PROVIDER
####################################################
provider "aws" {
  region = var.aws_region
}

####################################################
# VPC
####################################################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

####################################################
# AVAILABILITY ZONES
####################################################
data "aws_availability_zones" "available" {}

####################################################
# PUBLIC SUBNETS
####################################################
resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

####################################################
# PRIVATE SUBNETS
####################################################
resource "aws_subnet" "private" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + var.public_subnet_count)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

####################################################
# EKS CLUSTER
####################################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29.1"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = aws_vpc.main.id
  subnet_ids      = concat(
    aws_subnet.public[*].id,
    aws_subnet.private[*].id
  )

  # Managed Node Groups
  eks_managed_node_groups = {
    default = {
      desired_capacity = var.node_desired_capacity
      min_capacity     = var.node_min_capacity
      max_capacity     = var.node_max_capacity
      instance_type    = var.instance_type
      ami_id           = var.ami_id
    }
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}
