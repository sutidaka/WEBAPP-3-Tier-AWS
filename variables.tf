variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List CIDR for public subnet"
  type = list(string)
}

variable "private_subnet_cidrs" {
  description = "List CIDR for private subnet"
  type = list(string)
}

variable "admin_ip" {
  description = "IP Access SSH to bastion"
  type = string
}

variable "key_name" {
  description = "key access "
  type = string
}

variable "nat_instance_type" {
  description = "for nat_instance"
  type = string
}

variable "bastion_instance_type" {
  description = "for bastion_host"
  type = string
}
