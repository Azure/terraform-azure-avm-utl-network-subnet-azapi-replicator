# terraform-azure-avm-utl-network-subnet-azapi-replicator

This Azure Verified Module (AVM) utility module provides a migration path from `azurerm_subnet` resource to the generic `azapi_resource` provider. It acts as a replicator that accepts the same input variables as the AzureRM provider and outputs the necessary configurations for AzAPI resource deployment.

## Purpose

This module is designed to:
- **Facilitate migration** from AzureRM provider to AzAPI provider for subnet resources
- **Maintain compatibility** with existing `azurerm_subnet` configurations
- **Generate AzAPI outputs** including resource headers, body, locks, and sensitive data
- **Support all subnet features** including delegations, IP address pools, service endpoints, and network policies

## Key Features

- ✅ **Full feature parity** with `azurerm_subnet` resource
- ✅ **Schema validation disabled** to support all Azure API fields including read-only properties
- ✅ **Automatic state migration** support via output configurations
- ✅ **Comprehensive validation** for input parameters
- ✅ **Telemetry support** (opt-in/opt-out)
- ✅ **Lock management** for safe concurrent operations

## Important Notes

- **Schema Validation**: This module sets `schema_validation_enabled = false` in the AzAPI header to allow fields that Azure marks as read-only (like `delegation.actions`) to be sent during resource creation, matching AzureRM provider behavior.
- **Mutually Exclusive Options**: `address_prefixes` and `ip_address_pool` cannot be used together, just like `azurerm_subnet`.
- **Virtual Network ID**: Must be provided in the full Azure Resource ID format.
- **Delegation Actions**: While Azure marks delegation actions as read-only in the schema, this module includes them to maintain compatibility with AzureRM provider behavior.
