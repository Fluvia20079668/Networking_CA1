# ECR Repository URL
output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

# EKS Cluster Name
output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
}

# Public Subnet IDs
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

# EC2 Instance ID
output "instance_id" {
  value = aws_instance.web.id
}

# EC2 Public IP
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
