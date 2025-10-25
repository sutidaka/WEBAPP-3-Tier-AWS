# รับค่าจาก root module เพื่อใช้ใน resource ภายใน

variable "vpc_id" {
  description = "VPC ID TO Create subnet internal"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List CIDR For public subnet"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List CIDR For private subnet"
  type        = list(string)
}

variable "availability_zones" {
  description = "AZ TO Subnet"
  type        = list(string)
}