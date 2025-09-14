terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

# ดึง AZ ที่พร้อมใช้งาน
data "aws_availability_zones" "available" {
  state = "available"
}

# --- VPC ---
module "vpc" {
  source     = "./modules/vpc"
  name       = var.vpc_name
  cidr_block = var.vpc_cidr
}

# --- Subnet ---
module "subnet" {
  source               = "./modules/subnet"
  vpc_id               = module.vpc.vpc_id
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = data.aws_availability_zones.available.names
}

# --- Security Groups ---
module "security_group" {
  source  = "./modules/security-group"
  vpc_id  = module.vpc.vpc_id
  admin_ip = var.admin_ip
}

# --- NAT Instance ---
module "nat_instance" {
  source        = "./modules/ec2/nat-instance"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.subnet.public_subnet_ids[0]
  sg_id         = module.security_group.sg_nat_id
  instance_type = var.nat_instance_type
  key_name      = var.key_name
}

# --- Bastion Host ---
module "bastion" {
  source        = "./modules/ec2/bastion"
  subnet_id     = module.subnet.public_subnet_ids[0]
  sg_id         = module.security_group.sg_bastion_id
  instance_type = var.bastion_instance_type
  key_name      = var.key_name
}
