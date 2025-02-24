output "business_vpc_id" {
  description = "The ID of the business VPC"
  value       = alicloud_vpc.business.id
}

output "business_vswitch_ids" {
  description = "List of IDs for business VSwitches"
  value       = [for vswitch in alicloud_vswitch.business : vswitch.id]
}

output "transit_vpc_id" {
  description = "The ID of the transit VPC"
  value       = alicloud_vpc.transit.id
}

output "transit_vswitch_ids" {
  description = "List of IDs for transit VSwitches"
  value       = [for vswitch in alicloud_vswitch.transit : vswitch.id]
}

output "cen_instance_id" {
  description = "The ID of the CEN instance"
  value       = alicloud_cen_instance.default.id
}

output "cen_transit_router_id" {
  description = "The ID of the CEN transit router"
  value       = alicloud_cen_transit_router.default.transit_router_id
}

output "cen_transit_router_business_vpc_attachment_id" {
  description = "The attachment ID of the CEN transit router and business VPC"
  value       = alicloud_cen_transit_router_vpc_attachment.business.transit_router_attachment_id
}

output "cen_transit_router_transit_vpc_attachment_id" {
  description = "The attachment ID of the CEN transit router and transit VPC"
  value       = alicloud_cen_transit_router_vpc_attachment.transit.transit_router_attachment_id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.default.id
}

output "instance_ids" {
  description = "List of instance IDs in the transit VPC"
  value       = [for instance in alicloud_instance.default : instance.id]
}

output "network_interface_ids" {
  description = "List of network interface IDs"
  value       = [for eni in alicloud_ecs_network_interface.default : eni.id]
}

output "vpn_customer_gateway_ids" {
  description = "List of VPN customer gateway IDs"
  value       = [for gateway in alicloud_vpn_customer_gateway.default : gateway.id]
}

output "vpn_attachment_ids" {
  description = "List of VPN attachment IDs"
  value       = [for attachment in alicloud_vpn_gateway_vpn_attachment.default : attachment.id]
}

output "transit_router_vpn_attachment_ids" {
  description = "List of transit router VPN attachment IDs"
  value       = [for attachment in alicloud_cen_transit_router_vpn_attachment.default : attachment.id]
}
