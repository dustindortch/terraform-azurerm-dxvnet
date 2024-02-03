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
  default     = ["10.0.0.0/16"]
  description = "Virtual network address space."
  type        = list(string)

  validation {
    condition     = alltrue([for i in var.address_space : can(cidrhost(i, 1))])
    error_message = "Each address_space element must be a provided in proper CIDR notation."
  }
}

variable "bgp_community" {
  default     = null
  description = "BGP community attribute."
  type        = string
}

variable "ddos_protection_plan_id" {
  default     = null
  description = "DDoS protection plan ID."
  type        = string
}

variable "dns_servers" {
  default     = []
  description = "Virtual network DNS server IP addresses."
  type        = list(string)
}

variable "edge_zone" {
  default     = null
  description = "Virtual network edge zone."
  type        = string
}

variable "flow_timeout_in_minutes" {
  default     = null
  description = "Flow timeout in minutes."
  type        = number

  validation {
    condition     = var.flow_timeout_in_minutes == null ? true : var.flow_timeout_in_minutes >= 4 && var.flow_timeout_in_minutes <= 30
    error_message = "flow_timeout_in_minutes value must be between 4 and 30 minutes."
  }
}

variable "encryption" {
  default     = null
  description = "Virtual network encryption enforcement."
  type        = string

  validation {
    condition     = var.encryption == null ? true : contains(["DropUnencrypted", "AllowUnencrypted"], var.encryption)
    error_message = "Encryption must be either 'DropUnencrypted' or 'AllowUnencrypted'."
  }
}

variable "subnets" {
  default     = {}
  description = "Subnet map with the key as the subnet name."
  type = map(object({
    address_prefixes                              = list(string)
    private_endpoint_network_policies_enabled     = optional(bool, true)
    private_link_service_network_policies_enabled = optional(bool, true)
    service_endpoints                             = optional(list(string), [])
    service_endpoint_policy_ids                   = optional(list(string), null)
    delegation = optional(map(object({
      service_name = string
      actions      = list(string)
    })), {})
  }))

  validation {
    condition = alltrue(flatten([for k, v in var.subnets : [
      for address_prefix in v.address_prefixes : can(cidrhost(address_prefix, 1))
    ]]))
    error_message = "Each subnet address_prefix must be a provided in proper CIDR notation."
  }

  # Use this Azure CLI command to refresh the list of service endpoints:
  # locations=$(az account list-locations --query "[].name" --output tsv) && for location in $locations; do az network vnet list-endpoint-services --location eastus --query "[].name" --output tsv 2>/dev/null; done | sort | uniq | awk -F, -v OFS='","' -v q='"' '{$1=$1; print q $0 q}' | awk '{printf "%s%s",sep,$0; sep=",\n"} END{print ""}'
  validation {
    condition = alltrue(flatten([for k, v in var.subnets : [
      for service_endpoint in v.service_endpoints : contains([
        "Microsoft.AzureActiveDirectory",
        "Microsoft.AzureCosmosDB",
        "Microsoft.CognitiveServices",
        "Microsoft.ContainerRegistry",
        "Microsoft.EventHub",
        "Microsoft.KeyVault",
        "Microsoft.ServiceBus",
        "Microsoft.Sql",
        "Microsoft.Storage",
        "Microsoft.Storage.Global",
        "Microsoft.Web"
      ], service_endpoint)
    ]]))
    error_message = "Service endpoints must be one of the supported Azure service types."
  }

  # Use this Azure CLI command to refresh the list of available service delegations:
  # locations=$(az account list-locations --query "[].name" --output tsv) && for location in $locations; do az network vnet subnet list-available-delegations --query "[].serviceName" --location $location --output tsv 2>/dev/null; done | sort | uniq | awk -F, -v OFS='","' -v q='"' '{$1=$1; print q $0 q}' | awk '{printf "%s%s",sep,$0; sep=",\n"} END{print ""}'
  validation {
    condition = alltrue(flatten([for k, v in var.subnets : [
      for dk, dv in v.delegation : contains([
        "Dell.Storage/fileSystems",
        "GitHub.Network/networkSettings",
        "Informatica.DataManagement/organizations",
        "Microsoft.AVS/PrivateClouds",
        "Microsoft.ApiManagement/service",
        "Microsoft.Apollo/npu",
        "Microsoft.App/environments",
        "Microsoft.App/testClients",
        "Microsoft.AzureCommunicationsGateway/networkSettings",
        "Microsoft.AzureCosmosDB/clusters",
        "Microsoft.BareMetal/AzureHostedService",
        "Microsoft.BareMetal/AzureVMware",
        "Microsoft.BareMetal/CrayServers",
        "Microsoft.Batch/batchAccounts",
        "Microsoft.CloudTest/hostedpools",
        "Microsoft.CloudTest/images",
        "Microsoft.CloudTest/pools",
        "Microsoft.Codespaces/plans",
        "Microsoft.ContainerInstance/containerGroups",
        "Microsoft.ContainerService/managedClusters",
        "Microsoft.DBforMySQL/flexibleServers",
        "Microsoft.DBforMySQL/servers",
        "Microsoft.DBforMySQL/serversv2",
        "Microsoft.DBforPostgreSQL/flexibleServers",
        "Microsoft.DBforPostgreSQL/serversv2",
        "Microsoft.DBforPostgreSQL/singleServers",
        "Microsoft.Databricks/workspaces",
        "Microsoft.DelegatedNetwork/controller",
        "Microsoft.DevCenter/networkConnection",
        "Microsoft.DevOpsInfrastructure/pools",
        "Microsoft.DocumentDB/cassandraClusters",
        "Microsoft.Fidalgo/networkSettings",
        "Microsoft.HardwareSecurityModules/dedicatedHSMs",
        "Microsoft.Kusto/clusters",
        "Microsoft.LabServices/labplans",
        "Microsoft.Logic/integrationServiceEnvironments",
        "Microsoft.MachineLearningServices/workspaceComputes",
        "Microsoft.MachineLearningServices/workspaces",
        "Microsoft.Netapp/scaleVolumes",
        "Microsoft.Netapp/volumes",
        "Microsoft.Network/dnsResolvers",
        "Microsoft.Network/networkWatchers",
        "Microsoft.Orbital/orbitalGateways",
        "Microsoft.PowerAutomate/hostedRpa",
        "Microsoft.PowerPlatform/enterprisePolicies",
        "Microsoft.PowerPlatform/vnetaccesslinks",
        "Microsoft.ServiceFabricMesh/networks",
        "Microsoft.ServiceNetworking/trafficControllers",
        "Microsoft.Singularity/accounts/networks",
        "Microsoft.Singularity/accounts/npu",
        "Microsoft.Sql/managedInstances",
        "Microsoft.StoragePool/diskPools",
        "Microsoft.StreamAnalytics/streamingJobs",
        "Microsoft.Synapse/workspaces",
        "Microsoft.Web/hostingEnvironments",
        "Microsoft.Web/serverFarms",
        "NGINX.NGINXPLUS/nginxDeployments",
        "Oracle.Database/networkAttachments",
        "PaloAltoNetworks.Cloudngfw/firewalls",
        "PureStorage.Block/storagePools",
        "Qumulo.Storage/fileSystems"
        ],
      dv.service_name)
    ]]))
    error_message = "Delegation service_name must be one of the supported Azure service types."
  }

  # Azure CLI command to refresh the list of available actions for service delegations:
  # locations=$(az account list-locations --query "[].name" --output tsv) && for location in $locations; do az network vnet subnet list-available-delegations --query "[].actions[]" --location $location --output tsv 2>/dev/null; done | sort | uniq | awk -F, -v OFS='","' -v q='"' '{$1=$1; print q $0 q}' | awk '{printf "%s%s",sep,$0; sep=",\n"} END{print ""}'
  validation {
    condition = alltrue(flatten([
      for k, v in var.subnets : [
        for dk, dv in v.delegation : [
          for action in dv.actions : contains([
            "Microsoft.Network/networkinterfaces/*",
            "Microsoft.Network/publicIPAddresses/join/action",
            "Microsoft.Network/publicIPAddresses/read",
            "Microsoft.Network/virtualNetworks/read",
            "Microsoft.Network/virtualNetworks/subnets/action",
            "Microsoft.Network/virtualNetworks/subnets/join/action",
            "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
            "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
          ], action)
        ]
      ]]
    ))
    error_message = "Delegation actions must be from the supported Azure actions."
  }
}

variable "tags" {
  default     = {}
  description = "Virtual network tags."
  type        = map(string)
}
