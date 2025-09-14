# SG สำหรับ Bastion Host
resource "aws_security_group" "bastion" {
  name        = "sg_bastion"
  vpc_id      = var.vpc_id
  description = "Allow SSH from admin only"
  tags = {
    Name = "sg_bastion"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_bastion_ssh_ipv4" {
  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = var.admin_ip
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description = "Allow SSH From my ip "
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_bastion_ipv4" {
  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description = "Allow all outbound Traffic"
}


# SG สำหรับ ALB= Application Load Balance
resource "aws_security_group" "alb" {
  name = "sg_web_alb"
  vpc_id = var.vpc_id
  description = "Allow inbound HTTP 80 from the Internet to the ALB"
  tags = {
    Name = "sg_alb"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_web_for_alb" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
  description = "Allow HTTP from Internet"
}
resource "aws_vpc_security_group_egress_rule" "alb_all_out" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic"
}


# SG สำหรับ Instance EC2
resource "aws_security_group" "web_instance" {
  name = "sg_web_instance"
  vpc_id = var.vpc_id
  description = "Security group for Web EC2 instance"
  tags = {
    Name = "sg_instance"
  }
}
resource "aws_vpc_security_group_ingress_rule" "web_http_from_alb" {
  security_group_id            = aws_security_group.web_instance.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
  description                  = "Allow HTTP from ALB"
}
resource "aws_vpc_security_group_ingress_rule" "web_ssh_from_bastion" {
  security_group_id            = aws_security_group.web_instance.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.bastion.id
  description                  = "Allow SSH from Bastion"
}
resource "aws_vpc_security_group_egress_rule" "web_all_out" {
  security_group_id = aws_security_group.web_instance.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic"
}


# SG สำหรับ Database RDS
resource "aws_security_group" "Database" {
  name = "sg_database"
  vpc_id = var.vpc.id
  description = "Security Group for Database"
  tags = {
    Name = "sg_database"
  }
}
resource "aws_vpc_security_group_ingress_rule" "db_from_web" {
  security_group_id = aws_security_group.Database.id
  from_port = 5432
  to_port = 5432
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.web_instance.id
  description = "Allow DB access from Web Server EC2"
}
resource "aws_vpc_security_group_ingress_rule" "db_ssh_from_bastion" {
  security_group_id            = aws_security_group.Database.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.bastion.id
  description                  = "Allow SSH from Bastion"
}
resource "aws_vpc_security_group_egress_rule" "db_all_out" {
  security_group_id = aws_security_group.Database.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic"
}
