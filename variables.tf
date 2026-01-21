variable "name" {
  type        = string
  description = "(Required) The name of the subnet. Changing this forces a new resource to be created."
  nullable    = false
}

variable "virtual_network_id" {
  type        = string
  description = "(Required) The resource ID of the virtual network. Format: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}. Changing this forces a new resource to be created."
  nullable    = false
}

variable "address_prefixes" {
  type        = list(string)
  default     = null
  description = "(Optional) The address prefixes to use for the subnet."

  validation {
    condition = var.address_prefixes == null || (
      length(var.address_prefixes) >= 1 &&
      alltrue([for prefix in var.address_prefixes : prefix != ""])
    )
    error_message = "address_prefixes must have at least 1 item and all items must be non-empty strings."
  }
  validation {
    condition     = var.address_prefixes == null || var.ip_address_pool == null
    error_message = "address_prefixes and ip_address_pool are mutually exclusive. Only one can be set."
  }
}

variable "default_outbound_access_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Enable default outbound access to the internet for the subnet. Defaults to `true`."
  nullable    = false
}

variable "delegation" {
  type = list(object({
    name = string
    service_delegation = object({
      actions = optional(set(string))
      name    = string
    })
  }))
  default     = null
  description = <<-EOT
 - `name` - (Required) A name for this delegation.

 ---
 `service_delegation` block supports the following:
 - `actions` - (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values are `Microsoft.Network/networkinterfaces/*`, `Microsoft.Network/publicIPAddresses/join/action`, `Microsoft.Network/publicIPAddresses/read`, `Microsoft.Network/virtualNetworks/read`, `Microsoft.Network/virtualNetworks/subnets/action`, `Microsoft.Network/virtualNetworks/subnets/join/action`, `Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action`, and `Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action`.
 - `name` - (Required) The name of service to delegate to. Possible values are `GitHub.Network/networkSettings`, `Informatica.DataManagement/organizations`, `Microsoft.ApiManagement/service`, `Microsoft.Apollo/npu`, `Microsoft.App/environments`, `Microsoft.App/testClients`, `Microsoft.AVS/PrivateClouds`, `Microsoft.AzureCosmosDB/clusters`, `Microsoft.BareMetal/AzureHostedService`, `Microsoft.BareMetal/AzureHPC`, `Microsoft.BareMetal/AzurePaymentHSM`, `Microsoft.BareMetal/AzureVMware`, `Microsoft.BareMetal/CrayServers`, `Microsoft.BareMetal/MonitoringServers`, `Microsoft.Batch/batchAccounts`, `Microsoft.CloudTest/hostedpools`, `Microsoft.CloudTest/images`, `Microsoft.CloudTest/pools`, `Microsoft.Codespaces/plans`, `Microsoft.ContainerInstance/containerGroups`, `Microsoft.ContainerService/managedClusters`, `Microsoft.ContainerService/TestClients`, `Microsoft.Databricks/workspaces`, `Microsoft.DBforMySQL/flexibleServers`, `Microsoft.DBforMySQL/servers`, `Microsoft.DBforMySQL/serversv2`, `Microsoft.DBforPostgreSQL/flexibleServers`, `Microsoft.DBforPostgreSQL/serversv2`, `Microsoft.DBforPostgreSQL/singleServers`, `Microsoft.DelegatedNetwork/controller`, `Microsoft.DevCenter/networkConnection`, `Microsoft.DevOpsInfrastructure/pools`, `Microsoft.DocumentDB/cassandraClusters`, `Microsoft.Fidalgo/networkSettings`, `Microsoft.HardwareSecurityModules/dedicatedHSMs`, `Microsoft.Kusto/clusters`, `Microsoft.LabServices/labplans`, `Microsoft.Logic/integrationServiceEnvironments`, `Microsoft.MachineLearningServices/workspaces`, `Microsoft.Netapp/volumes`, `Microsoft.Network/applicationGateways`, `Microsoft.Network/dnsResolvers`, `Microsoft.Network/managedResolvers`, `Microsoft.Network/fpgaNetworkInterfaces`, `Microsoft.Network/networkWatchers.`, `Microsoft.Network/virtualNetworkGateways`, `Microsoft.Orbital/orbitalGateways`, `Microsoft.PowerAutomate/hostedRpa`, `Microsoft.PowerPlatform/enterprisePolicies`, `Microsoft.PowerPlatform/vnetaccesslinks`, `Microsoft.ServiceFabricMesh/networks`, `Microsoft.ServiceNetworking/trafficControllers`, `Microsoft.Singularity/accounts/networks`, `Microsoft.Singularity/accounts/npu`, `Microsoft.Sql/managedInstances`, `Microsoft.Sql/managedInstancesOnebox`, `Microsoft.Sql/managedInstancesStage`, `Microsoft.Sql/managedInstancesTest`, `Microsoft.Sql/servers`, `Microsoft.StoragePool/diskPools`, `Microsoft.StreamAnalytics/streamingJobs`, `Microsoft.Synapse/workspaces`, `Microsoft.Web/hostingEnvironments`, `Microsoft.Web/serverFarms`, `NGINX.NGINXPLUS/nginxDeployments`, `PaloAltoNetworks.Cloudngfw/firewalls`, `Qumulo.Storage/fileSystems`, and `Oracle.Database/networkAttachments`.
EOT
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "ip_address_pool" {
  type = object({
    id                     = string
    number_of_ip_addresses = string
  })
  default     = null
  description = <<-EOT
 - `id` - (Required) The ID of the Network Manager IP Address Management (IPAM) Pool.
 - `number_of_ip_addresses` - (Required) The number of IP addresses to allocated to the subnet. The value must be a string that represents a positive number, e.g., `"100"`.
EOT

  validation {
    condition = var.ip_address_pool == null || can(regex(
      "^/subscriptions/[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}/resourceGroups/[^/]+/providers/Microsoft\\.Network/networkManagers/[^/]+/ipamPools/[^/]+$",
      var.ip_address_pool.id
    ))
    error_message = "The ip_address_pool.id must be a valid Network Manager IPAM Pool ID in the format: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkManagers/{networkManagerName}/ipamPools/{ipamPoolName}."
  }
  validation {
    condition = var.ip_address_pool == null || can(regex(
      "^[1-9]\\d*$",
      var.ip_address_pool.number_of_ip_addresses
    ))
    error_message = "`number_of_ip_addresses` must be a string that represents a positive number."
  }
}

variable "private_endpoint_network_policies" {
  type        = string
  default     = "Disabled"
  description = "(Optional) Enable or Disable network policies for the private endpoint on the subnet. Possible values are `Disabled`, `Enabled`, `NetworkSecurityGroupEnabled` and `RouteTableEnabled`. Defaults to `Disabled`."
  nullable    = false

  validation {
    condition = contains([
      "Disabled",
      "Enabled",
      "NetworkSecurityGroupEnabled",
      "RouteTableEnabled"
    ], var.private_endpoint_network_policies)
    error_message = "private_endpoint_network_policies must be one of: Disabled, Enabled, NetworkSecurityGroupEnabled, RouteTableEnabled."
  }
}

variable "private_link_service_network_policies_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Enable or Disable network policies for the private link service on the subnet. Defaults to `true`."
  nullable    = false
}

variable "service_endpoint_policy_ids" {
  type        = set(string)
  default     = null
  description = "(Optional) The list of IDs of Service Endpoint Policies to associate with the subnet."
}

variable "service_endpoints" {
  type        = set(string)
  default     = null
  description = "(Optional) The list of Service endpoints to associate with the subnet. Possible values include: `Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage`, `Microsoft.Storage.Global` and `Microsoft.Web`."
}

variable "sharing_scope" {
  type        = string
  default     = null
  description = "(Optional) Set this property to Tenant to allow sharing subnet with other subscriptions in your AAD tenant. Possible values are `Tenant`. This property can only be set if `default_outbound_access_enabled` is set to `false`."

  validation {
    condition     = var.sharing_scope == null || var.sharing_scope == "Tenant"
    error_message = "sharing_scope must be \"Tenant\" when set."
  }
  validation {
    condition     = var.sharing_scope == null || !var.default_outbound_access_enabled
    error_message = "`sharing_scope` cannot be set if `default_outbound_access_enabled` is set to `true`"
  }
}

variable "timeouts" {
  type = object({
    create = optional(string, "30m")
    delete = optional(string, "30m")
    read   = optional(string, "5m")
    update = optional(string, "30m")
  })
  default = {
    create = "30m"
    delete = "30m"
    read   = "5m"
    update = "30m"
  }
  description = <<-EOT
 - `create` - (Optional) Specifies the timeout for create operations. Defaults to 30 minutes.
 - `delete` - (Optional) Specifies the timeout for delete operations. Defaults to 30 minutes.
 - `read` - (Optional) Specifies the timeout for read operations. Defaults to 5 minutes.
 - `update` - (Optional) Specifies the timeout for update operations. Defaults to 30 minutes.
EOT
  nullable    = false
}
