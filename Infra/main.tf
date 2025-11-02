terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.15"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  backend "s3" {
    bucket  = "my-github-actions-terraform-state"
    key     = "infra/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
  }
}

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
    Name        = "main-vpc"
    Environment = var.environment
  }
}

####################################################
# Availability Zones
####################################################
data "aws_availability_zones" "available" {
  state = "available"
}

####################################################
# Public Subnets
####################################################
resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

####################################################
# Private Subnets
####################################################
resource "aws_subnet" "private" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + var.public_subnet_count)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name        = "private-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

####################################################
# Internet Gateway
####################################################
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "main-igw"
    Environment = var.environment
  }
}

####################################################
# Route Table for Public Subnets
####################################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

####################################################
# EKS Cluster + Node Groups
####################################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = aws_vpc.main.id
  cluster_subnets = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)

  node_groups = {
    default = {
      desired_capacity = var.node_desired_capacity
      min_capacity     = var.node_min_capacity
      max_capacity     = var.node_max_capacity
      instance_type    = var.instance_type
      ami_type         = "AL2_x86_64"
      subnet_ids       = aws_subnet.private[*].id
    }
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}
