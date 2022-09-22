terraform {
  required_version = ">= 1.3.0"
}

resource "azurerm_network_ddos_protection_plan" "ddos" {
  count = var.enable_ddos_protection_plan == true ? 1 : 0

  name                = "${var.name}_ddosplan1"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.tags

  dynamic "ddos_protection_plan" {
    for_each = var.enable_ddos_protection_plan == true ? [1] : []

    content {
      id     = azurerm_network_ddos_protection_plan.ddos[0].id
      enable = var.enable_ddos_protection_plan
    }
  }
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name             = each.key
  address_prefixes = each.value.address_prefixes

  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name

  enforce_private_link_endpoint_network_policies = each.value.enforce_private_link_endpoint_network_policies
  enforce_private_link_service_network_policies  = each.value.enforce_private_link_service_network_policies
  service_endpoints                              = each.value.service_endpoints
}
