module "network" {
  source = "git::https://github.com/DNXLabs/terraform-aws-network.git?ref=2.0.0"

  vpc_cidr                      = "10.1.0.0/16"
  newbits                       = 8 # will create /24 subnets
  name                          = "MyVPC"
  multi_nat                     = false
  max_az                        = 2
  nat                           = false
  vpc_endpoint_s3_gateway       = false
  vpc_endpoint_dynamodb_gateway = false
}

provider "aws" {
  region = "sa-east-1"
}

