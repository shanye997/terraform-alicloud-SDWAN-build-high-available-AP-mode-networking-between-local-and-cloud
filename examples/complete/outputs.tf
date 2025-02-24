output "business_vpc_id" {
  description = "The ID of the business VPC"
  value       = module.complete.business_vpc_id
}

output "business_vswitch_ids" {
  description = "List of IDs for business VSwitches"
  value       = module.complete.business_vswitch_ids
}

output "transit_vpc_id" {
  description = "The ID of the transit VPC"
  value       = module.complete.transit_vpc_id
}

output "transit_vswitch_ids" {
  description = "List of IDs for transit VSwitches"
  value       = module.complete.transit_vswitch_ids
}

output "cen_instance_id" {
  description = "The ID of the CEN instance"
  value       = module.complete.cen_instance_id
}

output "cen_transit_router_id" {
  description = "The ID of the CEN transit router"
  value       = module.complete.cen_transit_router_id
}

output "cen_transit_router_business_vpc_attachment_id" {
  description = "The attachment ID of the CEN transit router and business VPC"
  value       = module.complete.cen_transit_router_business_vpc_attachment_id
}

output "cen_transit_router_transit_vpc_attachment_id" {
  description = "The attachment ID of the CEN transit router and transit VPC"
  value       = module.complete.cen_transit_router_transit_vpc_attachment_id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.complete.security_group_id
}

output "instance_ids" {
  description = "List of instance IDs in the transit VPC"
  value       = module.complete.instance_ids
}

output "network_interface_ids" {
  description = "List of network interface IDs"
  value       = module.complete.network_interface_ids
}

output "vpn_customer_gateway_ids" {
  description = "List of VPN customer gateway IDs"
  value       = module.complete.vpn_customer_gateway_ids
}

output "vpn_attachment_ids" {
  description = "List of VPN attachment IDs"
  value       = module.complete.vpn_attachment_ids
}

output "transit_router_vpn_attachment_ids" {
  description = "List of transit router VPN attachment IDs"
  value       = module.complete.transit_router_vpn_attachment_ids
}
