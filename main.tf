data "azapi_resource" "existing" {
  name                   = var.name
  parent_id              = var.virtual_network_id
  type                   = "Microsoft.Network/virtualNetworks/subnets@2025-01-01"
  ignore_not_found       = true
  response_export_values = ["*"]
}

locals {
  # Provider logic: if exactly 1 item, use addressPrefix (singular); otherwise use addressPrefixes (plural)
  address_prefix_singular = local.effective_address_prefixes != null && length(local.effective_address_prefixes) == 1 ? (
    local.effective_address_prefixes[0]
  ) : null
  address_prefixes_plural = local.effective_address_prefixes != null && length(local.effective_address_prefixes) > 1 ? (
    local.effective_address_prefixes
  ) : null
  # Replicate DiffSuppressFunc: suppress when ip_address_pool is set
  address_prefixes_should_suppress = var.ip_address_pool != null
  azapi_header = {
    type                      = "Microsoft.Network/virtualNetworks/subnets@2025-01-01"
    name                      = var.name
    location                  = null
    parent_id                 = var.virtual_network_id
    tags                      = null
    ignore_null_property      = true
    retry                     = null
    schema_validation_enabled = false
  }
  body = {
    properties = merge(
      local.address_prefix_singular != null ? { addressPrefix = local.address_prefix_singular } : {},
      local.address_prefixes_plural != null ? { addressPrefixes = local.address_prefixes_plural } : {},
      { defaultOutboundAccess = var.default_outbound_access_enabled },
      { privateEndpointNetworkPolicies = var.private_endpoint_network_policies },
      { privateLinkServiceNetworkPolicies = local.private_link_service_network_policies_value },
      var.service_endpoint_policy_ids != null ? {
        serviceEndpointPolicies = [for id in var.service_endpoint_policy_ids : { id = id }]
      } : {},
      var.service_endpoints != null ? {
        serviceEndpoints = [for endpoint in local.ordered_service_endpoints : { service = endpoint }]
      } : {},
      var.sharing_scope != null ? { sharingScope = var.sharing_scope } : {},
      var.delegation != null ? {
        delegations = [
          for delegation_item in var.delegation : {
            name = delegation_item.name
            properties = merge(
              { serviceName = delegation_item.service_delegation.name },
              delegation_item.service_delegation.actions != null ? {
                actions = [for action in delegation_item.service_delegation.actions : action]
              } : {}
            )
          }
        ]
      } : {},
      var.ip_address_pool != null ? {
        ipamPoolPrefixAllocations = [
          {
            numberOfIpAddresses = var.ip_address_pool.number_of_ip_addresses
            pool = {
              id = var.ip_address_pool.id
            }
          }
        ]
      } : {}
    )
  }
  desired_address_prefixes     = var.address_prefixes
  desired_service_endpoint_set = var.service_endpoints != null ? toset(var.service_endpoints) : toset([])
  effective_address_prefixes = local.address_prefixes_should_suppress ? (
    local.existing_address_prefixes != null ? local.existing_address_prefixes : local.desired_address_prefixes
  ) : local.desired_address_prefixes
  existing_address_prefixes = local.should_read_existing_address_prefixes && data.azapi_resource.existing.exists ? (
    try(data.azapi_resource.existing.output.properties.addressPrefixes, null) != null ?
    try(data.azapi_resource.existing.output.properties.addressPrefixes, null) :
    (try(data.azapi_resource.existing.output.properties.addressPrefix, null) != null ?
    [try(data.azapi_resource.existing.output.properties.addressPrefix, null)] : null)
  ) : null
  # Extract existing ip_address_pool values for update validation
  existing_ipam_pool_allocations = data.azapi_resource.existing.exists ? (
    try(data.azapi_resource.existing.output.properties.ipamPoolPrefixAllocations, null)
  ) : null
  existing_number_of_ip_addresses = local.existing_ipam_pool_allocations != null && length(local.existing_ipam_pool_allocations) > 0 ? (
    try(local.existing_ipam_pool_allocations[0].numberOfIpAddresses, null)
  ) : null
  existing_service_endpoint_names = local.existing_service_endpoints != null ? (
    [for ep in local.existing_service_endpoints : ep.service if ep.service != null]
  ) : []
  existing_service_endpoints = local.should_read_existing_service_endpoints && data.azapi_resource.existing.exists ? (
    try(data.azapi_resource.existing.output.properties.serviceEndpoints, null)
  ) : null
  # Trigger ForceNew when decreasing number_of_ip_addresses (Update would fail)
  ip_address_pool_decrease_trigger = (
    var.ip_address_pool != null &&
    local.existing_number_of_ip_addresses != null &&
    tonumber(var.ip_address_pool.number_of_ip_addresses) < tonumber(local.existing_number_of_ip_addresses)
  ) ? "decrease-not-allowed" : null
  locks = [
    "azurerm_virtual_network.${local.virtual_network_name}"
  ]
  # Preserve Azure's order for existing endpoints that are still in the desired set,
  # then append any new endpoints in sorted order
  ordered_service_endpoints = local.should_read_existing_service_endpoints && length(local.existing_service_endpoint_names) > 0 ? (
    concat(
      [for ep in local.existing_service_endpoint_names : ep if contains(local.desired_service_endpoint_set, ep)],
      sort([for ep in local.desired_service_endpoint_set : ep if !contains(local.existing_service_endpoint_names, ep)])
    )
  ) : (var.service_endpoints != null ? sort(var.service_endpoints) : [])
  # Convert private_link_service_network_policies_enabled boolean to API string
  private_link_service_network_policies_value = var.private_link_service_network_policies_enabled != null ? (
    var.private_link_service_network_policies_enabled ? "Enabled" : "Disabled"
  ) : "Enabled"
  replace_triggers_external_values = {
    name                             = { value = var.name }
    virtual_network_id               = { value = var.virtual_network_id }
    ip_address_pool_decrease_trigger = local.ip_address_pool_decrease_trigger
  }
  sensitive_body = {
    properties = {}
  }
  sensitive_body_version = {
    # All possible sensitive field paths with try(tostring(...), "null")
    # Example: "properties.virtualMachineProfile.userData" = try(tostring(var.user_data_version), "null")
  }
  # DiffSuppressFunc handling for address_prefixes
  should_read_existing_address_prefixes = var.ip_address_pool != null
  # Service endpoints ordering: Azure doesn't preserve input order for service endpoints.
  # Since service_endpoints is a set in AzureRM provider (order doesn't matter),
  # we should preserve Azure's stored order to avoid unnecessary updates.
  should_read_existing_service_endpoints = var.service_endpoints != null
  # Extract virtual network name from parent_id for locks
  virtual_network_name = split("/", var.virtual_network_id)[8]
}
