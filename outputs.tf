output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.subnet.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.subnet.private_subnet_ids
}

output "bastion_public_ip" {
  value = module.bastion.public_ip
}

output "nat_public_ip" {
  value = module.nat_instance.public_ip
}
