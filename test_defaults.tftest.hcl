provider "azurerm" {
  features {}
}

variables {
  name                = "vnet-test-virtual-network"
  resource_group_name = "rg-test-virtual-network"
  location            = "eastus"
  address_space       = ["10.0.1.0/24"]

  subnets = {
    "default" = {
      address_prefixes  = ["10.0.1.0/26"]
      service_endpoints = ["Microsoft.Sql","Microsoft.Web"]

      enforce_private_link_service_network_policies = true
    }
    "GatewaySubnet" = {
      address_prefixes  = ["10.0.1.64/26"]
    }
    "AzureFirewallSubnet" = {
      address_prefixes  = ["10.0.1.128/26"]
    }
  }
}

run "setup" {
  module {
    source = "./testing/setup"
  }
}

run "defaults" {
  assert {
    condition     = azurerm_virtual_network.vnet.name == "vnet-test-virtual-network"
    error_message = "The virtual network name vnet-test-virtual-network did not match var.name"
  }

  assert {
    condition     = azurerm_subnet.subnets["default"].name == "default"
    error_message = "The subnet named default was not created."
  }

  assert {
    condition     = azurerm_subnet.subnets["GatewaySubnet"].name == "GatewaySubnet"
    error_message = "The subnet named GatewaySubnet was not created."
  }

  assert {
    condition     = azurerm_subnet.subnets["AzureFirewallSubnet"].name == "AzureFirewallSubnet"
    error_message = "The subnet named AzureFirewallSubnet was not created."
  }
}