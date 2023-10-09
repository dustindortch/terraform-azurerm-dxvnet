<!-- BEGIN_TF_DOCS -->
name                = "myVirtualNetwork"
resource_group_name = "myResourceGroup"
location            = "eastus"
address_space       = ["10.0.1.0/24"]

subnets = {
  "default" = {
    address_prefixes                               = ["10.0.1.0/26"]
    service_endpoints                              = ["Microsoft.Sql", "Microsoft.Web"]
    enforce_private_link_endpoint_network_policies = true
  }
  "GatewaySubnet" = {
    address_prefixes = ["10.0.1.64/26"]
  }
  "AzureFirewallSubnet" = {
    address_prefixes = ["10.0.1.128/26"]
  }
}
tags = {
  CreatedBy = "Terraform"
  Module    = "terraform-azurerm-dxvnet"
}
<!-- END_TF_DOCS -->