variable "business_vpc" {
  description = "The parameters of business vpc and vswitches."
  type = object({
    vpc_name   = optional(string, null)
    cidr_block = string
    vswitches = list(object({
      vswitch_name = optional(string, null)
      cidr_block   = string
      zone_id      = string
    }))
  })
  default = {
    vpc_name   = "business_vpc"
    cidr_block = "10.1.0.0/16"
    vswitches = [{
      cidr_block = "10.1.1.0/24"
      zone_id    = "cn-shanghai-m"
      }, {
      cidr_block = "10.1.2.0/24"
      zone_id    = "cn-shanghai-n"
    }]
  }
}

variable "transit_vpc" {
  description = "The parameters of transit vpc and vswitches."
  type = object({
    vpc_name   = optional(string, null)
    cidr_block = string
    vswitches = list(object({
      vswitch_name = optional(string, null)
      cidr_block   = string
      zone_id      = string
    }))
  })
  default = {
    vpc_name   = "transit_vpc"
    cidr_block = "172.16.0.0/16"
    vswitches = [{
      cidr_block = "172.16.0.0/24"
      zone_id    = "cn-shanghai-m"
      }, {
      cidr_block = "172.16.1.0/24"
      zone_id    = "cn-shanghai-n"
    }]
  }
}

variable "transit_router_cidr" {
  description = "The cidr of transit router."
  type        = string
  default     = "10.10.10.0/24"
}

variable "instance_config" {
  description = "The parameters of instance."
  type = object({
    image_id                   = string
    instance_name              = optional(string, null)
    description                = optional(string, null)
    instance_charge_type       = optional(string, "PostPaid")
    instance_type              = optional(string, "ecs.c6.xlarge")
    password                   = optional(string, null)
    internet_max_bandwidth_out = optional(number, 100)
    internet_charge_type       = optional(string, "PayByTraffic")
  })
  default = {
    image_id = "m-uf6c1shi2lk1xt196ybz"
  }
}

variable "vpn_attachment" {
  description = "The parameters of the VPN attachment"
  type = object({
    local_subnet         = string
    remote_subnet        = string
    vpn_attachment_name  = optional(string, null)
    network_type         = optional(string, "private")
    effect_immediately   = optional(bool, true)
    enable_dpd           = optional(bool, true)
    enable_nat_traversal = optional(bool, true)
    ike_config = optional(list(object({
      ike_auth_alg = optional(string, "sha1")
      ike_enc_alg  = optional(string, "aes")
      ike_version  = optional(string, "ikev2")
      ike_mode     = optional(string, "main")
      ike_lifetime = optional(number, 86400)
      psk          = optional(string, "tfvpnattachment")
      ike_pfs      = optional(string, "group2")
    })), [{}])
    ipsec_config = optional(list(object({
      ipsec_pfs      = optional(string, "group2")
      ipsec_enc_alg  = optional(string, "aes")
      ipsec_auth_alg = optional(string, "sha1")
      ipsec_lifetime = optional(number, 86400)
    })), [{}])
    bgp_config = optional(list(object({
      enable       = optional(bool, true)
      local_asn    = optional(number, 45104)
      tunnel_cidr  = optional(string, "169.254.10.0/30")
      local_bgp_ip = optional(string, "169.254.10.1")
    })), [{}])
  })

  validation {
    condition     = length(var.vpn_attachment.ike_config) <= 1 && length(var.vpn_attachment.ipsec_config) <= 1 && length(var.vpn_attachment.bgp_config) <= 1
    error_message = "The number of ike_config, ipsec_config and bgp_config must be less than or equal to 1."
  }

  default = {
    local_subnet  = "0.0.0.0/0"
    remote_subnet = "0.0.0.0/0"
  }
}

