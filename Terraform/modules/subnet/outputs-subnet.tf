output "public_subnet_ids" {
  description = "List ของ Public Subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List ของ Private Subnet IDs"
  value       = aws_subnet.private[*].id
}
