Terraform module to build a on-premise to aloud active-active high-availability networking architecture on Alibaba Cloud

terraform-alicloud-SDWAN-build-high-available-AP-mode-networking-between-local-and-cloud
======================================

[English](https://github.com/alibabacloud-automation/terraform-alicloud-SDWAN-build-high-available-AP-mode-networking-between-local-and-cloud/blob/main/README.md) | 简体中文

本方案支持使用3rd SDWAN构建本地到云上主备高可用组网架构，本方案的高可用实现依赖BGP。当主用SDWAN链路故障时，自动切换到备用链路实现容灾。  
支持创建：
- 中转VPC和业务VPC以及对应子网
- 安全组用于SDWAN镜像
- SDWAN品牌fortigate镜像实例（fortigate 7.2.7vm image），您可选择其他支持bgp over ipsec的SDWAN品牌实现
- SDWAN镜像实例配置辅助网卡用于内网通信
- CEN实例
- VPC到CEN的连接，并实现路由学习和路由同步
- SDWAN镜像到CEN的ipsec vpn连接，并实现路由学习和路由同步
- CEN路由策略实现上云和下云方向的BGP主备配置

架构图:

![image](https://raw.githubusercontent.com/alibabacloud-automation/terraform-alicloud-SDWAN-build-high-available-AP-mode-networking-between-local-and-cloud/main/scripts/diagram-CN.png)

## 用法

```hcl
provider "alicloud" {
  region = "cn-shanghai"
}

module "complete" {
  source = "alibabacloud-automation/SDWAN-build-high-available-AP-mode-networking-between-local-and-cloud/alicloud"

  business_vpc = {
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

  transit_vpc = {
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

  transit_router_cidr = "10.10.10.0/24"
  instance_config = {
    image_id = "m-uf6c1shi2lk1xt196ybz"
  }

  vpn_attachment = {
    local_subnet  = "0.0.0.0/0"
    remote_subnet = "0.0.0.0/0"
  }
}
```

## 示例

* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-SDWAN-build-high-available-AP-mode-networking-between-local-and-cloud/tree/main/examples/complete)


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_cen_instance.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_instance) | resource |
| [alicloud_cen_route_map.in_vpn](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_route_map) | resource |
| [alicloud_cen_route_map.out_vpn](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_route_map) | resource |
| [alicloud_cen_transit_router.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router) | resource |
| [alicloud_cen_transit_router_cidr.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_cidr) | resource |
| [alicloud_cen_transit_router_route_table_association.business](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_association) | resource |
| [alicloud_cen_transit_router_route_table_association.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_association) | resource |
| [alicloud_cen_transit_router_route_table_association.transit](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_association) | resource |
| [alicloud_cen_transit_router_route_table_propagation.business](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_propagation) | resource |
| [alicloud_cen_transit_router_route_table_propagation.transit](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_propagation) | resource |
| [alicloud_cen_transit_router_route_table_propagation.vpn_m_attch_propagation](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_propagation) | resource |
| [alicloud_cen_transit_router_vpc_attachment.business](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_vpc_attachment) | resource |
| [alicloud_cen_transit_router_vpc_attachment.transit](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_vpc_attachment) | resource |
| [alicloud_cen_transit_router_vpn_attachment.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_vpn_attachment) | resource |
| [alicloud_ecs_network_interface.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/ecs_network_interface) | resource |
| [alicloud_ecs_network_interface_attachment.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/ecs_network_interface_attachment) | resource |
| [alicloud_instance.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/instance) | resource |
| [alicloud_security_group.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/security_group) | resource |
| [alicloud_security_group_rule.allow_all_tcp](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/security_group_rule) | resource |
| [alicloud_security_group_rule.allow_all_udp](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/security_group_rule) | resource |
| [alicloud_security_group_rule.fortigate_ingress_icmp](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/security_group_rule) | resource |
| [alicloud_vpc.business](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vpc.transit](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vpn_customer_gateway.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vpn_customer_gateway) | resource |
| [alicloud_vpn_gateway_vpn_attachment.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vpn_gateway_vpn_attachment) | resource |
| [alicloud_vswitch.business](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_vswitch.transit](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_cen_transit_router_route_tables.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/cen_transit_router_route_tables) | data source |
| [alicloud_regions.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/regions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_business_vpc"></a> [business\_vpc](#input\_business\_vpc) | The parameters of business vpc and vswitches. | <pre>object({<br>    vpc_name   = optional(string, null)<br>    cidr_block = string<br>    vswitches = list(object({<br>      vswitch_name = optional(string, null)<br>      cidr_block   = string<br>      zone_id      = string<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_cen_config"></a> [cen\_config](#input\_cen\_config) | The parameters of cen. | <pre>object({<br>    cen_instance_name = optional(string, "sdwan-cen")<br>    description       = optional(string, null)<br>  })</pre> | `{}` | no |
| <a name="input_cen_route_map"></a> [cen\_route\_map](#input\_cen\_route\_map) | The parameters of cen route map. | <pre>object({<br>    in = object({<br>      priority   = optional(number, 1)<br>      map_result = optional(string, "Permit")<br>      preference = optional(number, 1)<br>    })<br>    out = object({<br>      priority   = optional(number, 1)<br>      map_result = optional(string, "Permit")<br>      prepend_as_path = optional(list(string), ["1"])<br>    })<br>  })</pre> | <pre>{<br>  "in": {},<br>  "out": {}<br>}</pre> | no |
| <a name="input_eni_name_prefix"></a> [eni\_name\_prefix](#input\_eni\_name\_prefix) | The name of ecs network interface. | `string` | `"eni"` | no |
| <a name="input_instance_config"></a> [instance\_config](#input\_instance\_config) | The parameters of instance. | <pre>object({<br>    image_id                   = string<br>    instance_name              = optional(string, null)<br>    description                = optional(string, null)<br>    instance_charge_type       = optional(string, "PostPaid")<br>    instance_type              = optional(string, "ecs.c6.xlarge")<br>    password                   = optional(string, null)<br>    internet_max_bandwidth_out = optional(number, 100)<br>    internet_charge_type       = optional(string, "PayByTraffic")<br>  })</pre> | n/a | yes |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | The name of security group. | `string` | `null` | no |
| <a name="input_transit_router_cidr"></a> [transit\_router\_cidr](#input\_transit\_router\_cidr) | The cidr of transit router. | `string` | n/a | yes |
| <a name="input_transit_vpc"></a> [transit\_vpc](#input\_transit\_vpc) | The parameters of transit vpc and vswitches. | <pre>object({<br>    vpc_name   = optional(string, null)<br>    cidr_block = string<br>    vswitches = list(object({<br>      vswitch_name = optional(string, null)<br>      cidr_block   = string<br>      zone_id      = string<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_vpc_customer_gateway"></a> [vpc\_customer\_gateway](#input\_vpc\_customer\_gateway) | The parameters of vpc customer gateway. | <pre>object({<br>    name_prefix = optional(string, null)<br>    asn         = optional(string, null)<br>  })</pre> | <pre>{<br>  "asn": "65534",<br>  "name_prefix": "cgw"<br>}</pre> | no |
| <a name="input_vpn_attachment"></a> [vpn\_attachment](#input\_vpn\_attachment) | The parameters of the VPN attachment | <pre>object({<br>    local_subnet         = string<br>    remote_subnet        = string<br>    vpn_attachment_name  = optional(string, null)<br>    network_type         = optional(string, "private")<br>    effect_immediately   = optional(bool, true)<br>    enable_dpd           = optional(bool, true)<br>    enable_nat_traversal = optional(bool, true)<br>    ike_config = optional(list(object({<br>      ike_auth_alg = optional(string, "sha1")<br>      ike_enc_alg  = optional(string, "aes")<br>      ike_version  = optional(string, "ikev2")<br>      ike_mode     = optional(string, "main")<br>      ike_lifetime = optional(number, 86400)<br>      psk          = optional(string, "tfvpnattachment")<br>      ike_pfs      = optional(string, "group2")<br>    })), [{}])<br>    ipsec_config = optional(list(object({<br>      ipsec_pfs      = optional(string, "group2")<br>      ipsec_enc_alg  = optional(string, "aes")<br>      ipsec_auth_alg = optional(string, "sha1")<br>      ipsec_lifetime = optional(number, 86400)<br>    })), [{}])<br>    bgp_config = optional(list(object({<br>      enable       = optional(bool, true)<br>      local_asn    = optional(number, 45104)<br>      tunnel_cidr  = optional(string, "169.254.10.0/30")<br>      local_bgp_ip = optional(string, "169.254.10.1")<br>    })), [{}])<br>  })</pre> | n/a | yes |

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

## 提交问题

如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

## 作者

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## 许可

MIT Licensed. See LICENSE for full details.

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
