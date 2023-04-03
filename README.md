# terraform-azurerm-dxvnet

Module to create a virtual network resource and associated subnets in Microsoft Azure.

This module implements a hierarchical structure for subnet definitions instead of a set of lists like the [terraform-azurerm-vnet](https://github.com/Azure/terraform-azurerm-network) module does, which leads to fewer errors or misassociations of one list to another list incorrectly.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_ddos_protection_plan.ddos](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_ddos_protection_plan) | resource |
| [azurerm_subnet.subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | Address spaces assigned to virtual network | `list(string)` | n/a | yes |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | DNS servers for Azure virtual network | `list(string)` | `[]` | no |
| <a name="input_enable_ddos_protection_plan"></a> [enable\_ddos\_protection\_plan](#input\_enable\_ddos\_protection\_plan) | Enable standard ddos protection plan | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Location to deploy virtual network | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Virtual network name | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name to deploy virtual network | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | n/a | <pre>map(object({<br>    address_prefixes                               = list(string)<br>    enforce_private_link_endpoint_network_policies = optional(bool, false)<br>    enforce_private_link_service_network_policies  = optional(bool, false)<br>    service_endpoints                              = optional(list(string))<br>    delegation                                     = optional(map(object{}))<br>}))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign to virtual network | `map` | <pre>{<br>  "CreatedBy": "Terraform",<br>  "Module": "terraform-azurerm-dxvnet"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address_space"></a> [address\_space](#output\_address\_space) | Virtual network address space |
| <a name="output_id"></a> [id](#output\_id) | Virtual network id |
| <a name="output_location"></a> [location](#output\_location) | Virtual network location |
| <a name="output_name"></a> [name](#output\_name) | Virtual network name |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Virtual network subnets |
<!-- END_TF_DOCS -->
