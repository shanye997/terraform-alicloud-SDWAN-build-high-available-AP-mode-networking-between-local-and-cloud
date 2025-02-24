
# Complete

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_complete"></a> [complete](#module\_complete) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_business_vpc"></a> [business\_vpc](#input\_business\_vpc) | The parameters of business vpc and vswitches. | <pre>object({<br>    vpc_name   = optional(string, null)<br>    cidr_block = string<br>    vswitches = list(object({<br>      vswitch_name = optional(string, null)<br>      cidr_block   = string<br>      zone_id      = string<br>    }))<br>  })</pre> | <pre>{<br>  "cidr_block": "10.1.0.0/16",<br>  "vpc_name": "business_vpc",<br>  "vswitches": [<br>    {<br>      "cidr_block": "10.1.1.0/24",<br>      "zone_id": "cn-shanghai-m"<br>    },<br>    {<br>      "cidr_block": "10.1.2.0/24",<br>      "zone_id": "cn-shanghai-n"<br>    }<br>  ]<br>}</pre> | no |
| <a name="input_cen_config"></a> [cen\_config](#input\_cen\_config) | The parameters of cen. | <pre>object({<br>    cen_instance_name = optional(string, "sdwan-cen")<br>    description       = optional(string, null)<br>  })</pre> | `{}` | no |
| <a name="input_cen_route_map"></a> [cen\_route\_map](#input\_cen\_route\_map) | The parameters of cen route map. | <pre>object({<br>    in = object({<br>      priority   = optional(number, 1)<br>      map_result = optional(string, "Permit")<br>      preference = optional(number, 1)<br>    })<br>    out = object({<br>      priority        = optional(number, 1)<br>      map_result      = optional(string, "Permit")<br>      prepend_as_path = optional(list(string), ["1"])<br>    })<br>  })</pre> | <pre>{<br>  "in": {},<br>  "out": {}<br>}</pre> | no |
| <a name="input_eni_name_prefix"></a> [eni\_name\_prefix](#input\_eni\_name\_prefix) | The name of ecs network interface. | `string` | `"eni"` | no |
| <a name="input_instance_config"></a> [instance\_config](#input\_instance\_config) | The parameters of instance. | <pre>object({<br>    image_id                   = string<br>    instance_name              = optional(string, null)<br>    description                = optional(string, null)<br>    instance_charge_type       = optional(string, "PostPaid")<br>    instance_type              = optional(string, "ecs.c6.xlarge")<br>    password                   = optional(string, null)<br>    internet_max_bandwidth_out = optional(number, 100)<br>    internet_charge_type       = optional(string, "PayByTraffic")<br>  })</pre> | <pre>{<br>  "image_id": "m-uf6c1shi2lk1xt196ybz"<br>}</pre> | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | The name of security group. | `string` | `null` | no |
| <a name="input_transit_router_cidr"></a> [transit\_router\_cidr](#input\_transit\_router\_cidr) | The cidr of transit router. | `string` | `"10.10.10.0/24"` | no |
| <a name="input_transit_vpc"></a> [transit\_vpc](#input\_transit\_vpc) | The parameters of transit vpc and vswitches. | <pre>object({<br>    vpc_name   = optional(string, null)<br>    cidr_block = string<br>    vswitches = list(object({<br>      vswitch_name = optional(string, null)<br>      cidr_block   = string<br>      zone_id      = string<br>    }))<br>  })</pre> | <pre>{<br>  "cidr_block": "172.16.0.0/16",<br>  "vpc_name": "transit_vpc",<br>  "vswitches": [<br>    {<br>      "cidr_block": "172.16.0.0/24",<br>      "zone_id": "cn-shanghai-m"<br>    },<br>    {<br>      "cidr_block": "172.16.1.0/24",<br>      "zone_id": "cn-shanghai-n"<br>    }<br>  ]<br>}</pre> | no |
| <a name="input_vpc_customer_gateway"></a> [vpc\_customer\_gateway](#input\_vpc\_customer\_gateway) | The parameters of vpc customer gateway. | <pre>object({<br>    name_prefix = optional(string, null)<br>    asn         = optional(string, null)<br>  })</pre> | <pre>{<br>  "asn": "65534",<br>  "name_prefix": "cgw"<br>}</pre> | no |
| <a name="input_vpn_attachment"></a> [vpn\_attachment](#input\_vpn\_attachment) | The parameters of the VPN attachment | <pre>object({<br>    local_subnet         = string<br>    remote_subnet        = string<br>    vpn_attachment_name  = optional(string, null)<br>    network_type         = optional(string, "private")<br>    effect_immediately   = optional(bool, true)<br>    enable_dpd           = optional(bool, true)<br>    enable_nat_traversal = optional(bool, true)<br>    ike_config = optional(list(object({<br>      ike_auth_alg = optional(string, "sha1")<br>      ike_enc_alg  = optional(string, "aes")<br>      ike_version  = optional(string, "ikev2")<br>      ike_mode     = optional(string, "main")<br>      ike_lifetime = optional(number, 86400)<br>      psk          = optional(string, "tfvpnattachment")<br>      ike_pfs      = optional(string, "group2")<br>    })), [{}])<br>    ipsec_config = optional(list(object({<br>      ipsec_pfs      = optional(string, "group2")<br>      ipsec_enc_alg  = optional(string, "aes")<br>      ipsec_auth_alg = optional(string, "sha1")<br>      ipsec_lifetime = optional(number, 86400)<br>    })), [{}])<br>    bgp_config = optional(list(object({<br>      enable       = optional(bool, true)<br>      local_asn    = optional(number, 45104)<br>      tunnel_cidr  = optional(string, "169.254.10.0/30")<br>      local_bgp_ip = optional(string, "169.254.10.1")<br>    })), [{}])<br>  })</pre> | <pre>{<br>  "local_subnet": "0.0.0.0/0",<br>  "remote_subnet": "0.0.0.0/0"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_business_vpc_id"></a> [business\_vpc\_id](#output\_business\_vpc\_id) | The ID of the business VPC |
| <a name="output_business_vswitch_ids"></a> [business\_vswitch\_ids](#output\_business\_vswitch\_ids) | List of IDs for business VSwitches |
| <a name="output_cen_instance_id"></a> [cen\_instance\_id](#output\_cen\_instance\_id) | The ID of the CEN instance |
| <a name="output_cen_transit_router_business_vpc_attachment_id"></a> [cen\_transit\_router\_business\_vpc\_attachment\_id](#output\_cen\_transit\_router\_business\_vpc\_attachment\_id) | The attachment ID of the CEN transit router and business VPC |
| <a name="output_cen_transit_router_id"></a> [cen\_transit\_router\_id](#output\_cen\_transit\_router\_id) | The ID of the CEN transit router |
| <a name="output_cen_transit_router_transit_vpc_attachment_id"></a> [cen\_transit\_router\_transit\_vpc\_attachment\_id](#output\_cen\_transit\_router\_transit\_vpc\_attachment\_id) | The attachment ID of the CEN transit router and transit VPC |
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids) | List of instance IDs in the transit VPC |
| <a name="output_network_interface_ids"></a> [network\_interface\_ids](#output\_network\_interface\_ids) | List of network interface IDs |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_transit_router_vpn_attachment_ids"></a> [transit\_router\_vpn\_attachment\_ids](#output\_transit\_router\_vpn\_attachment\_ids) | List of transit router VPN attachment IDs |
| <a name="output_transit_vpc_id"></a> [transit\_vpc\_id](#output\_transit\_vpc\_id) | The ID of the transit VPC |
| <a name="output_transit_vswitch_ids"></a> [transit\_vswitch\_ids](#output\_transit\_vswitch\_ids) | List of IDs for transit VSwitches |
| <a name="output_vpn_attachment_ids"></a> [vpn\_attachment\_ids](#output\_vpn\_attachment\_ids) | List of VPN attachment IDs |
| <a name="output_vpn_customer_gateway_ids"></a> [vpn\_customer\_gateway\_ids](#output\_vpn\_customer\_gateway\_ids) | List of VPN customer gateway IDs |
<!-- END_TF_DOCS -->