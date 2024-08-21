output "vpc-id" {
  value = module.network.vpc_id
}

output "subnets-public-id" {
  value = module.network.public_subnet_ids
}

output "subnets-private-id" {
  value = module.network.private_subnet_ids
}

output "nat-gateway-id" {
  value = module.network.nat_gateway_ids
}

output "internet-gateway-id" {
  value = module.network.internet_gateway_id
}