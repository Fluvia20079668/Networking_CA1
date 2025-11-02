variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_count" {
  default = 2
}

variable "private_subnet_count" {
  default = 2
}

variable "cluster_name" {
  default = "my-eks-cluster"
}

variable "cluster_version" {
  default = "1.29"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "ami_id" {
  default = ""  # leave blank for latest Amazon EKS optimized AMI
}

variable "node_desired_capacity" {
  default = 2
}

variable "node_min_capacity" {
  default = 1
}

variable "node_max_capacity" {
  default = 3
}

variable "environment" {
  default = "dev"
}
