variable "project_name" {
  description = "Prefix name for project resources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for NAT Instance (Amazon Linux 2)"
  type        = string
}

variable "nat_instance_type" {
  description = "Instance type for NAT Instance"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Public Subnet ID to launch the NAT Instance"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID for NAT Instance"
  type        = string
}

variable "tags" {
  description = "Extra tags for NAT Instance"
  type        = map(string)
  default     = {}
}

