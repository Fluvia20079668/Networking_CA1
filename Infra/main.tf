#####################################
# Provider
#####################################
provider "aws" {
  region = var.aws_region
}

#####################################
# Variables
#####################################
variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "eks_name" {
  type    = string
  default = "my-eks-cluster"
}

variable "suffix" {
  type    = string
  default = "yc3rg8"
}

#####################################
# Data Sources
#####################################
# Availability zones
data "aws_availability_zones" "available" {}

#####################################
# VPC (if not already existing)
#####################################
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "main-vpc-${var.suffix}"
  }
}

#####################################
# Existing Public Subnets (example)
#####################################
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}-${var.suffix}"
  }
}

#####################################
# Extra Public Subnets
#####################################
resource "aws_subnet" "public_extra" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 10)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-extra-subnet-${count.index}-${var.suffix}"
  }
}

#####################################
# EKS IAM Role
#####################################
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role-${var.suffix}"

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

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

#####################################
# EKS Cluster
#####################################
resource "aws_eks_cluster" "main" {
  name     = var.eks_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    # Combine old public subnets and new subnets
    subnet_ids = concat(
      aws_subnet.public[*].id,
      aws_subnet.public_extra[*].id
    )

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    Name = var.eks_name
  }
}

#####################################
# Output
#####################################
output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.main.arn
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "extra_public_subnets" {
  value = aws_subnet.public_extra[*].id
}
