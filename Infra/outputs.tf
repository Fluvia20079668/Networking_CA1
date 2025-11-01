output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.app.repository_url
  sensitive   = false
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks.name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_certificate" {
  description = "EKS cluster CA data (base64)"
  value       = aws_eks_cluster.eks.certificate_authority[0].data
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}
