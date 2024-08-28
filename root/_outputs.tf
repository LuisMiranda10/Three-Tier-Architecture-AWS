output "vpc-id" {
  value = module.network.vpc_id
}

output "subnets-public-id" {
  value = module.network.public_subnet_ids
}

output "subnets-private-id" {
  value = module.network.private_subnet_ids
}

output "subsnet-secure-id" {
  value = module.network.secure_subnet_ids
}

output "internet-gateway-id" {
  value = module.network.internet_gateway_id
}

output "dns_validation-record" {
  value = module.acm_certificate.dns_validation_records
}