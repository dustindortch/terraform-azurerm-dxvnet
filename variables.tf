variable "name" {
  type = string
  description = "Virtual network name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name to deploy virtual network"
}

variable "location" {
  type        = string
  description = "Location to deploy virtual network"
}

variable "address_space" {
  type        = list(string)
  description = "Address spaces assigned to virtual network"
}

variable "dns_servers" {
  type        = list(string)
  description = "DNS servers for Azure virtual network"

  default = []
}

variable "tags" {
  description = "Tags to assign to virtual network"
  default = {
    CreatedBy = "Terraform"
    Module    = "terraform-azurerm-dxvnet"
  }
}

variable "enable_ddos_protection_plan" {
  type = bool
  description = "Enable standard ddos protection plan"
  default = false
}

variable "subnets" {
  type = map(object({
    address_prefixes                               = list(string)
    enforce_private_link_endpoint_network_policies = optional(bool, false)
    enforce_private_link_service_network_policies  = optional(bool, false)
    service_endpoints                              = optional(list(string))
  }))
}
