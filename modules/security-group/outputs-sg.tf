output "sg_bastion_id" {
  description = "ID of the Bastion Security Group"
  value       = aws_security_group.bastion.id
}

output "sg_web_alb.id"{
  description = "ID of the ALB Security Group"
  value       = aws_security_group.alb.id
}

output "sg_web_instance.id"{
  description = "ID of the Web EC2 Security Group"
  value       = aws_security_group.web_instance.id
}

output "sg_database.id"{
  description = "ID of the Database EC2 Security Group"
  value       = aws_security_group.Database.id
}
