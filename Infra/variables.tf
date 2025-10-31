variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources in"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "subnet_count" {
  type        = number
  description = "Number of public subnets"
  default     = 2
}

variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}
