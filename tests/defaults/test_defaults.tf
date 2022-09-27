terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.21.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  resource_group_name  = "rg-test-virtual-network"
  location             = "eastus"
  virtual_network_name = "vnet-test-virtual-network"
  address_space        = ["10.0.1.0/24"]
}

module "main" {
  source = "../.."

  name                = local.virtual_network_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = local.address_space

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

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
}

resource "test_assertions" "defaults" {
  component = "defaults"

  equal "name" {
    description = "Virtual Network name is vnet-test-virtual-group"
    got         = module.main.name
    want        = local.virtual_network_name
  }

  equal "location" {
    description = "Region is East US"
    got         = module.main.location
    want        = local.location
  }

  equal "address_space" {
    description = "Virtual Network address space is [\"10.0.1.0/24\"]"
    got         = module.main.address_space
    want        = tolist(local.address_space)
  }
}

resource "test_assertions" "subnets" {
  component = "subnets"

  equal "default" {
    description = "Default subnet created"
    got         = module.main.subnets["default"].name
    want        = "default"
  }

  equal "GatewaySubnet" {
    description = "GatewaySubnet subnet created"
    got         = module.main.subnets["GatewaySubnet"].name
    want        = "GatewaySubnet"
  }

  equal "AzureFirewallSubnet" {
    description = "AzureFirewallSubnet subnet created"
    got         = module.main.subnets["AzureFirewallSubnet"].name
    want        = "AzureFirewallSubnet"
  }
}