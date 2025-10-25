# Var input from terrafrom.tfvars รับค่าจริงมาสร้างเป็นตัวแปรเพื่อนำไปใช้งาน #

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "availability_zones" {
  description = "List of Availability Zones to use (for single-AZ lab)"
  type        = list(string)
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
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List CIDR for private subnet"
  type        = list(string)
}

# variable "admin_ip" {
#   description = "Your current public IP address for SSH access"
#   type        = string
# }

variable "key_name" {
  description = "key access The name of the EC2 key pair "
  type        = string
}

variable "ami_id" {
  description = "ami-id on ec2"
  type        = string
}

variable "project_name" {
  description = "for name project "
  type        = string
}

variable "nat_instance_type" {
  description = "for nat_instance"
  type        = string
}

variable "bastion_instance_type" {
  description = "for bastion_host"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

