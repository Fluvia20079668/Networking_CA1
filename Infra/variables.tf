variable "aws_region" {
  type    = string
  default = "us-east-1"
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
  default = "ami-0c02fb55956c7d316"  # Amazon Linux 2 in us-east-1
}

variable "instance_type" {
  type    = string
  default = "t3.micro"  # Free Tier eligible
}
