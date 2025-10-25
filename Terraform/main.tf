terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

#  ดึง Public IP ปัจจุบันของเครื่อง (Dynamic)
data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}

locals {
  admin_ip = format("%s/32", trimspace(data.http.my_ip.response_body))
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
  availability_zones   = var.availability_zones
}

# --- Security Groups ---
module "security_group" {
  source   = "./modules/security-group"
  vpc_id   = module.vpc.vpc_id
  admin_ip = local.admin_ip
}

# --- NAT Instance ---
module "nat_instance" {
  source            = "./modules/ec2/nat_instance"
  project_name      = var.project_name
  ami_id            = var.ami_id
  nat_instance_type = var.nat_instance_type
  subnet_id         = module.subnet.public_subnet_ids[0]
  key_name          = var.key_name
  security_group_id = module.security_group.sg_nat_instance_id
  tags              = var.tags
}

# --- Bastion Host ---
module "bastion" {
  source        = "./modules/ec2/bastion"
  project_name  = var.project_name
  ami_id        = var.ami_id
  instance_type = var.bastion_instance_type
  subnet_id     = module.subnet.public_subnet_ids[0]
  sg_id         = module.security_group.sg_bastion_id
  key_name      = var.key_name
  tags          = var.tags
}


# --- Internet Gateway ---#

module "igw" {
  source = "./modules/network/internet-gateway"
  vpc_id = module.vpc.vpc_id
  project_name = var.project_name
}

  # --- Routing-Table ---#
module "route_table" {
  source             = "./modules/network/route-table"
  vpc_id             = module.vpc.vpc_id
  project_name       = var.project_name
  igw_id             = module.igw.igw_id
  nat_instance_id    = module.nat_instance.nat_instance_id
  public_subnet_ids  = module.subnet.public_subnet_ids
  private_subnet_ids = module.subnet.private_subnet_ids
}