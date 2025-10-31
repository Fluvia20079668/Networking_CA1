output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "instance_id" {
  value = aws_instance.web.id
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
