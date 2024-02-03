terraform {
  required_version = ">= 1.6.0"
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.tags

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan_id == null ? [] : [0]

    content {
      enable = true
      id     = var.ddos_protection_plan_id
    }
  }

  dynamic "encryption" {
    for_each = var.encryption == null ? [] : [0]

    content {
      enforcement = var.encryption
    }
  }
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name = each.key

  address_prefixes     = each.value.address_prefixes
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name

  private_endpoint_network_policies_enabled     = each.value.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
  service_endpoints                             = each.value.service_endpoints
  service_endpoint_policy_ids                   = each.value.service_endpoint_policy_ids

  dynamic "delegation" {
    for_each = each.value.delegation

    content {
      name = delegation.key

      service_delegation {
        name    = delegation.value["service_name"]
        actions = delegation.value["actions"]
      }
    }
  }
}
