output "id" {
  description = "Virtual network id"
  value       = azurerm_virtual_network.vnet.id
}

output "name" {
  description = "Virtual network name"
  value       = azurerm_virtual_network.vnet.name
}

output "location" {
  description = "Virtual network location"
  value       = azurerm_virtual_network.vnet.location
}

output "address_space" {
  description = "Virtual network address space"
  value       = azurerm_virtual_network.vnet.address_space
}

output "subnets" {
  description = "Virtual network subnets"
  value       = azurerm_subnet.subnets
}