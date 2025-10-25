# modules/vpc/main.tf
# สร้าง VPC โดยใช้ค่า var.name และ var.cidr_block ที่ส่งมาจาก root

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name      = var.name
    Project   = "web-3tier"
    ManagedBy = "Terraform"
  }
}
