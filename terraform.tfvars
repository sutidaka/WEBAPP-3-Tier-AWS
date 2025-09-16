//data Actual value to variables.tf//

// Region & Network
aws_region = "ap-southeast-1"
vpc_name   = "networkprod-a"
vpc_cidr   = "10.0.0.0/16"

public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

// Access & Key
admin_ip = "43.249.61.217/32"
key_name = "Key-APP"


// EC2 instance types
nat_instance_type     = "t3.micro"
bastion_instance_type = "t3.micro"

// Required for NAT instance module
ami_id       = "ami-03b60f6e83d527b4c" # Amazon Linux 2
project_name = "webapp"