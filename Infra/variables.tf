variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_count" {
  type    = number
  default = 2
}

variable "ami_id" {
  type    = string
  default = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "s3_backend_bucket" {
  type    = string
  default = "my-terraform-state-bucket"  # Replace with your S3 bucket
}

variable "dynamodb_table" {
  type    = string
  default = "terraform-locks"           # Replace with your DynamoDB table
}


