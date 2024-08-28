module "network" {
  source = "git::https://github.com/DNXLabs/terraform-aws-network.git?ref=2.0.0"

  vpc_cidr                      = "10.1.0.0/16"
  newbits                       = 8 # will create /24 subnets
  name                          = "MyVPC"
  multi_nat                     = false
  max_az                        = 2
  vpc_endpoint_s3_gateway       = false
  vpc_endpoint_dynamodb_gateway = false
}

module "acm_certificate" {
  source = "git::https://github.com/DNXLabs/terraform-aws-acm-certificate?ref=0.2.2"

  domain_names             = ["example.com", "*.example.com"]
  validation_method        = "DNS"
  create_validation_record = false
}

provider "aws" {
  region = "sa-east-1"
}

