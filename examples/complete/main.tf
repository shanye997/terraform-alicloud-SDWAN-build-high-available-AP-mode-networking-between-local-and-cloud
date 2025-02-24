provider "alicloud" {
  region = "cn-shanghai"
}

module "complete" {
  source = "../.."

  business_vpc = var.business_vpc

  transit_vpc = var.transit_vpc

  transit_router_cidr = var.transit_router_cidr
  instance_config     = var.instance_config

  vpn_attachment = var.vpn_attachment
}