module "network" {
  source = "git::https://github.com/DNXLabs/terraform-aws-network.git?ref=1.5.1"

  vpc_cidr              = "10.1.0.0/16"
  newbits               = 8 # will create /24 subnets
  name                  = "MyVPC"
  multi_nat             = false
}

provider "aws" {
  region = "sa-east-1"
}