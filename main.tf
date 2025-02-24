# VPC and Vswitches
resource "alicloud_vpc" "business" {
  vpc_name   = var.business_vpc.vpc_name
  cidr_block = var.business_vpc.cidr_block
}

resource "alicloud_vswitch" "business" {
  for_each = { for i, v in var.business_vpc.vswitches : v.zone_id => v }

  vpc_id     = alicloud_vpc.business.id
  cidr_block = each.value.cidr_block
  zone_id    = each.key
}

resource "alicloud_vpc" "transit" {
  vpc_name   = var.transit_vpc.vpc_name
  cidr_block = var.transit_vpc.cidr_block
}

resource "alicloud_vswitch" "transit" {
  for_each = { for i, v in var.transit_vpc.vswitches : v.zone_id => v }

  vpc_id     = alicloud_vpc.transit.id
  cidr_block = each.value.cidr_block
  zone_id    = each.key
}


# CEN
resource "alicloud_cen_instance" "default" {
  cen_instance_name = var.cen_config.cen_instance_name
  description       = var.cen_config.description
}

resource "alicloud_cen_transit_router" "default" {
  cen_id = alicloud_cen_instance.default.id
}

resource "alicloud_cen_transit_router_cidr" "default" {
  transit_router_id = alicloud_cen_transit_router.default.transit_router_id
  cidr              = var.transit_router_cidr
}


resource "alicloud_cen_transit_router_vpc_attachment" "business" {
  auto_publish_route_enabled = true
  cen_id                     = alicloud_cen_instance.default.id
  transit_router_id          = alicloud_cen_transit_router_cidr.default.transit_router_id
  vpc_id                     = alicloud_vpc.business.id

  dynamic "zone_mappings" {
    for_each = alicloud_vswitch.business
    content {
      zone_id    = zone_mappings.value.zone_id
      vswitch_id = zone_mappings.value.id
    }
  }
}

resource "alicloud_cen_transit_router_vpc_attachment" "transit" {
  auto_publish_route_enabled = true
  cen_id                     = alicloud_cen_instance.default.id
  transit_router_id          = alicloud_cen_transit_router_cidr.default.transit_router_id
  vpc_id                     = alicloud_vpc.transit.id
  dynamic "zone_mappings" {
    for_each = alicloud_vswitch.transit
    content {
      zone_id    = zone_mappings.value.zone_id
      vswitch_id = zone_mappings.value.id
    }
  }
}


data "alicloud_cen_transit_router_route_tables" "default" {
  transit_router_id = alicloud_cen_transit_router.default.transit_router_id
}

resource "alicloud_cen_transit_router_route_table_association" "business" {
  transit_router_route_table_id = data.alicloud_cen_transit_router_route_tables.default.tables[0].transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_vpc_attachment.business.transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_propagation" "business" {
  transit_router_route_table_id = data.alicloud_cen_transit_router_route_tables.default.tables[0].transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_vpc_attachment.business.transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_association" "transit" {
  transit_router_route_table_id = data.alicloud_cen_transit_router_route_tables.default.tables[0].transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_vpc_attachment.transit.transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_propagation" "transit" {
  transit_router_route_table_id = data.alicloud_cen_transit_router_route_tables.default.tables[0].transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_vpc_attachment.transit.transit_router_attachment_id
}


# security group
resource "alicloud_security_group" "default" {
  security_group_name = var.security_group_name
  vpc_id              = alicloud_vpc.transit.id
}

resource "alicloud_security_group_rule" "allow_all_tcp" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/65535"
  priority          = 1
  security_group_id = alicloud_security_group.default.id
  cidr_ip           = "0.0.0.0/0"

}

resource "alicloud_security_group_rule" "allow_all_udp" {
  type              = "ingress"
  ip_protocol       = "udp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/65535"
  priority          = 1
  security_group_id = alicloud_security_group.default.id
  cidr_ip           = "0.0.0.0/0"

}

resource "alicloud_security_group_rule" "fortigate_ingress_icmp" {
  type              = "ingress"
  ip_protocol       = "icmp"
  nic_type          = "intranet"
  policy            = "accept"
  priority          = 1
  security_group_id = alicloud_security_group.default.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_instance" "default" {
  for_each = alicloud_vswitch.transit

  availability_zone          = each.value.zone_id
  instance_charge_type       = var.instance_config.instance_charge_type
  image_id                   = var.instance_config.image_id
  instance_type              = var.instance_config.instance_type
  security_groups            = [alicloud_security_group.default.id]
  vswitch_id                 = each.value.id
  instance_name              = var.instance_config.instance_name
  password                   = var.instance_config.password
  internet_max_bandwidth_out = var.instance_config.internet_max_bandwidth_out
  internet_charge_type       = var.instance_config.internet_charge_type
}

resource "alicloud_ecs_network_interface" "default" {
  for_each = alicloud_vswitch.transit

  network_interface_name = "${var.eni_name_prefix}_${each.value.zone_id}"
  vswitch_id             = each.value.id
  security_group_ids     = [alicloud_security_group.default.id]
}

resource "alicloud_ecs_network_interface_attachment" "default" {
  for_each = alicloud_instance.default

  network_interface_id = alicloud_ecs_network_interface.default[each.key].id
  instance_id          = each.value.id
}

# VPN
resource "alicloud_vpn_customer_gateway" "default" {
  for_each = alicloud_vswitch.transit

  customer_gateway_name = "${var.vpc_customer_gateway.name_prefix}_${each.value.zone_id}"
  asn                   = var.vpc_customer_gateway.asn
  ip_address            = alicloud_ecs_network_interface.default[each.key].primary_ip_address
}

resource "alicloud_vpn_gateway_vpn_attachment" "default" {
  for_each = alicloud_vpn_customer_gateway.default

  customer_gateway_id = each.value.id
  vpn_attachment_name = var.vpn_attachment.vpn_attachment_name
  network_type        = var.vpn_attachment.network_type
  local_subnet        = var.vpn_attachment.local_subnet
  remote_subnet       = var.vpn_attachment.remote_subnet
  effect_immediately  = var.vpn_attachment.effect_immediately

  dynamic "ike_config" {
    for_each = var.vpn_attachment.ike_config
    content {
      ike_auth_alg = ike_config.value.ike_auth_alg
      ike_enc_alg  = ike_config.value.ike_enc_alg
      ike_version  = ike_config.value.ike_version
      ike_mode     = ike_config.value.ike_mode
      ike_lifetime = ike_config.value.ike_lifetime
      psk          = ike_config.value.psk
      ike_pfs      = ike_config.value.ike_pfs
    }
  }

  dynamic "ipsec_config" {
    for_each = var.vpn_attachment.ipsec_config
    content {
      ipsec_pfs      = ipsec_config.value.ipsec_pfs
      ipsec_enc_alg  = ipsec_config.value.ipsec_enc_alg
      ipsec_auth_alg = ipsec_config.value.ipsec_auth_alg
      ipsec_lifetime = ipsec_config.value.ipsec_lifetime
    }
  }

  dynamic "bgp_config" {
    for_each = var.vpn_attachment.bgp_config
    content {
      enable       = bgp_config.value.enable
      local_asn    = bgp_config.value.local_asn
      tunnel_cidr  = bgp_config.value.tunnel_cidr
      local_bgp_ip = bgp_config.value.local_bgp_ip
    }
  }
}


resource "alicloud_cen_transit_router_vpn_attachment" "default" {
  for_each = alicloud_vswitch.transit

  auto_publish_route_enabled = true
  cen_id                     = alicloud_cen_instance.default.id
  transit_router_id          = alicloud_cen_transit_router_cidr.default.transit_router_id
  vpn_id                     = alicloud_vpn_gateway_vpn_attachment.default[each.key].id
  zone {
    zone_id = each.value.zone_id
  }
}


resource "alicloud_cen_transit_router_route_table_association" "default" {
  for_each = alicloud_cen_transit_router_vpn_attachment.default

  transit_router_route_table_id = data.alicloud_cen_transit_router_route_tables.default.tables[0].transit_router_route_table_id
  transit_router_attachment_id  = each.value.id
}


resource "alicloud_cen_transit_router_route_table_propagation" "vpn_m_attch_propagation" {
  for_each = alicloud_cen_transit_router_vpn_attachment.default

  transit_router_route_table_id = data.alicloud_cen_transit_router_route_tables.default.tables[0].transit_router_route_table_id
  transit_router_attachment_id  = each.value.id
}


data "alicloud_regions" "default" {
  current = true
}

locals {
  vpn_attachment_ids = [
    for vpn_attachment in alicloud_cen_transit_router_vpn_attachment.default : vpn_attachment.id
  ]
}

resource "alicloud_cen_route_map" "in_vpn" {
  cen_id              = alicloud_cen_instance.default.id
  cen_region_id       = data.alicloud_regions.default.regions[0].id
  priority            = var.cen_route_map.in.priority
  transmit_direction  = "RegionIn"
  map_result          = var.cen_route_map.in.map_result
  source_instance_ids = [local.vpn_attachment_ids[0]]
  preference          = var.cen_route_map.in.preference
}

resource "alicloud_cen_route_map" "out_vpn" {
  cen_id                   = alicloud_cen_instance.default.id
  cen_region_id            = data.alicloud_regions.default.regions[0].id
  priority                 = var.cen_route_map.out.priority
  transmit_direction       = "RegionOut"
  map_result               = var.cen_route_map.out.map_result
  destination_instance_ids = [local.vpn_attachment_ids[1]]
  prepend_as_path          = var.cen_route_map.out.prepend_as_path
}

