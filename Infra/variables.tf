# AWS region
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-west-2"
}

# VPC CIDR
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Number of public subnets
variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
  default     = 2
}

# Number of private subnets
variable "private_subnet_count" {
  description = "Number of private subnets"
  type        = number
  default     = 2
}

