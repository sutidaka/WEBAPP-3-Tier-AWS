resource "aws_instance" "nat_instance" {
  ami                         = var.ami_id
  instance_type               = var.nat_instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  key_name                    = var.key_name

  # Security group ของ NAT instance (ควรสร้างไว้ใน module sg แล้วส่งเข้ามา)
  vpc_security_group_ids = [var.aws_security_group.nat_instance.id]

  # Tagging เพื่อการจัดการง่าย
  tags = merge(
    {
      Name = "${var.project_name}-nat_instance"
    },
    var.tags
  )
}

# เพิ่มการตั้งค่าให้ instance นี้ forward traffic ได้
resource "aws_ec2_instance_connect_endpoint" "nat_connect" {
  subnet_id = var.subnet_id
}

# Elastic IP สำหรับ NAT Instance
resource "aws_eip" "nat_eip" {
  instance = aws_instance.nat_instance.id
  vpc = true 

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}
