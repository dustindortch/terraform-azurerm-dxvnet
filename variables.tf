variable "name" {
  description = "Virtual network name"
  type        = string
}

variable "resource_group_name" {
  description = "Virtual network resource group name"
  type        = string
}

variable "location" {
  description = "Virtual network region"
  type        = string

  # Use this Azure CLI command to refresh the list of regions:
  # az account list-locations --query "[].name" --output tsv | sort | awk -F, -v OFS='","' -v q='"' '{$1=$1; print q $0 q}' | awk '{printf "%s%s",sep,$0; sep=",\n"} END{print ""}'
  validation {
    condition = contains([
      "asia",
      "asiapacific",
      "australia",
      "australiacentral",
      "australiacentral2",
      "australiaeast",
      "australiasoutheast",
      "brazil",
      "brazilsouth",
      "brazilsoutheast",
      "brazilus",
      "canada",
      "canadacentral",
      "canadaeast",
      "centralindia",
      "centralus",
      "centraluseuap",
      "centralusstage",
      "eastasia",
      "eastasiastage",
      "eastus",
      "eastus2",
      "eastus2euap",
      "eastus2stage",
      "eastusstage",
      "eastusstg",
      "europe",
      "france",
      "francecentral",
      "francesouth",
      "germany",
      "germanynorth",
      "germanywestcentral",
      "global",
      "india",
      "israelcentral",
      "italynorth",
      "japan",
      "japaneast",
      "japanwest",
      "jioindiacentral",
      "jioindiawest",
      "korea",
      "koreacentral",
      "koreasouth",
      "northcentralus",
      "northcentralusstage",
      "northeurope",
      "norway",
      "norwayeast",
      "norwaywest",
      "polandcentral",
      "qatarcentral",
      "singapore",
      "southafrica",
      "southafricanorth",
      "southafricawest",
      "southcentralus",
      "southcentralusstage",
      "southeastasia",
      "southeastasiastage",
      "southindia",
      "sweden",
      "swedencentral",
      "switzerland",
      "switzerlandnorth",
      "switzerlandwest",
      "uae",
      "uaecentral",
      "uaenorth",
      "uk",
      "uksouth",
      "ukwest",
      "unitedstates",
      "unitedstateseuap",
      "westcentralus",
      "westeurope",
      "westindia",
      "westus",
      "westus2",
      "westus2stage",
      "westus3",
      "westusstage"
    ], var.location)
    error_message = "Location must be a valid Azure region."
  }
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
  type        = bool
  description = "Enable standard ddos protection plan"
  default     = false
}

variable "subnets" {
  type = map(object({
    address_prefixes                               = list(string)
    enforce_private_link_endpoint_network_policies = optional(bool, false)
    enforce_private_link_service_network_policies  = optional(bool, false)
    service_endpoints                              = optional(list(string))
    delegation = optional(map(object({
      service_name = optional(string)
      actions      = optional(list(string))
    })), {})
  }))
}
