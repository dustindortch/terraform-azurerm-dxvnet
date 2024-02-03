# terraform-azurerm-dxvnet

Module to create a virtual network resource and associated subnets in Microsoft Azure.

This module implements a hierarchical structure for subnet definitions instead of a set of lists like the [terraform-azurerm-vnet](https://github.com/Azure/terraform-azurerm-network) module does, which leads to fewer errors or misassociations of one list to another list incorrectly.

Please review the [example.tfvars](https://github.com/dustindortch/terraform-azurerm-dxvnet/blob/main/example.tfvars) for data structure examples.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.75.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet.subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | Virtual network address space. | `list(string)` | <pre>[<br>  "10.0.0.0/16"<br>]</pre> | no |
| <a name="input_bgp_community"></a> [bgp\_community](#input\_bgp\_community) | BGP community attribute. | `string` | `null` | no |
| <a name="input_ddos_protection_plan_id"></a> [ddos\_protection\_plan\_id](#input\_ddos\_protection\_plan\_id) | DDoS protection plan ID. | `string` | `null` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | Virtual network DNS server IP addresses. | `list(string)` | `[]` | no |
| <a name="input_edge_zone"></a> [edge\_zone](#input\_edge\_zone) | Virtual network edge zone. | `string` | `null` | no |
| <a name="input_encryption"></a> [encryption](#input\_encryption) | Virtual network encryption enforcement. | `string` | `null` | no |
| <a name="input_flow_timeout_in_minutes"></a> [flow\_timeout\_in\_minutes](#input\_flow\_timeout\_in\_minutes) | Flow timeout in minutes. | `number` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Virtual network region | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Virtual network name | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Virtual network resource group name | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnet map with the key as the subnet name. | <pre>map(object({<br>    address_prefixes                              = list(string)<br>    private_endpoint_network_policies_enabled     = optional(bool, true)<br>    private_link_service_network_policies_enabled = optional(bool, true)<br>    service_endpoints                             = optional(list(string), [])<br>    service_endpoint_policy_ids                   = optional(list(string), null)<br>    delegation = optional(map(object({<br>      service_name = string<br>      actions      = list(string)<br>    })), {})<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Virtual network tags. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address_space"></a> [address\_space](#output\_address\_space) | Virtual network address space |
| <a name="output_id"></a> [id](#output\_id) | Virtual network id |
| <a name="output_location"></a> [location](#output\_location) | Virtual network location |
| <a name="output_name"></a> [name](#output\_name) | Virtual network name |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Virtual network subnets |
<!-- END_TF_DOCS -->
