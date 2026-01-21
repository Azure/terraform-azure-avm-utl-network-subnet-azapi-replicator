# Migration Plan: azurerm_subnet to azapi_resource

## Resource Identification

**Source Resource**: `azurerm_subnet`

**Target Azure Resource Type**: `Microsoft.Network/virtualNetworks/subnets`

**API Version**: `2025-01-01` (based on SDK import path: `resource-manager/network/2025-01-01/subnets`)

## Evidence from AzureRM Provider Source Code

From the create function (`resourceSubnetCreate`) in the azurerm provider source code:
- Import statement: `"github.com/hashicorp/go-azure-sdk/resource-manager/network/2025-01-01/subnets"`
- ID construction: `commonids.NewSubnetID(subscriptionId, resourceGroupName, virtualNetworkName, name)` creates a subnet within a virtual network
- Resource type structure: Virtual Networks -> Subnets (child resource)
- This confirms the Azure resource type is `Microsoft.Network/virtualNetworks/subnets`

## Schema Analysis Summary

The schema was analyzed from the `resourceSubnet()` function in the azurerm provider. The resource includes:
- 3 Required arguments (name, resource_group_name, virtual_network_name)
- 7 Optional arguments
- 2 Optional blocks (delegation with nested structure, ip_address_pool)
- Timeouts block with all 4 timeout types supported

## Planning Task List

| No. | Path | Type | Required | Status | Proof Doc Markdown Link |
|-----|------|------|----------|--------|------------------------|
| 1 | name | Argument | Yes | Completed | [1.name.md](1.name.md) |
| 2 | resource_group_name | Argument | Yes | ✅ Completed | [2.resource_group_name.md](2.resource_group_name.md) |
| 3 | virtual_network_name | Argument | Yes | ✅ Completed | [3.virtual_network_name.md](3.virtual_network_name.md) |
| 4 | address_prefixes | Argument | No | ✅ Completed | [4.address_prefixes.md](4.address_prefixes.md) |
| 5 | default_outbound_access_enabled | Argument | No | ✅ Completed | [5.default_outbound_access_enabled.md](5.default_outbound_access_enabled.md) |
| 6 | private_endpoint_network_policies | Argument | No | ✅ Completed | [6.private_endpoint_network_policies.md](6.private_endpoint_network_policies.md) |
| 7 | private_link_service_network_policies_enabled | Argument | No | ✅ Completed | [7.private_link_service_network_policies_enabled.md](7.private_link_service_network_policies_enabled.md) |
| 8 | service_endpoint_policy_ids | Argument | No | ✅ Completed | [8.service_endpoint_policy_ids.md](8.service_endpoint_policy_ids.md) |
| 9 | service_endpoints | Argument | No | ✅ Completed | [9.service_endpoints.md](9.service_endpoints.md) |
| 10 | sharing_scope | Argument | No | ✅ Completed | [10.sharing_scope.md](10.sharing_scope.md) |
| 11 | __check_root_hidden_fields__ | HiddenFieldsCheck | Yes | ✅ Completed | [11.__check_root_hidden_fields__.md](11.__check_root_hidden_fields__.md) |
| 12 | delegation | Block | No | ✅ Completed | [12.delegation.md](12.delegation.md) |
| 13 | delegation.name | Argument | Yes | ✅ Completed | [13.delegation.name.md](13.delegation.name.md) |
| 14 | delegation.service_delegation | Block | Yes | ✅ Completed | [14.delegation.service_delegation.md](14.delegation.service_delegation.md) |
| 15 | delegation.service_delegation.name | Argument | Yes | ✅ Completed | [15.delegation.service_delegation.name.md](15.delegation.service_delegation.name.md) |
| 16 | delegation.service_delegation.actions | Argument | No | ✅ Completed | [16.delegation.service_delegation.actions.md](16.delegation.service_delegation.actions.md) |
| 17 | ip_address_pool | Block | No | ✅ Completed | [17.ip_address_pool.md](17.ip_address_pool.md) |
| 18 | ip_address_pool.id | Argument | Yes | ✅ Completed | [18.ip_address_pool.id.md](18.ip_address_pool.id.md) |
| 19 | ip_address_pool.number_of_ip_addresses | Argument | Yes | ✅ Completed | [19.ip_address_pool.number_of_ip_addresses.md](19.ip_address_pool.number_of_ip_addresses.md) |
| 20 | timeouts | Block | No | ✅ Completed | [20.timeouts.md](20.timeouts.md) |
| 21 | timeouts.create | Argument | No | ✅ Completed | [21.timeouts.create.md](21.timeouts.create.md) |
| 22 | timeouts.delete | Argument | No | ✅ Completed | [22.timeouts.delete.md](22.timeouts.delete.md) |
| 23 | timeouts.read | Argument | No | ✅ Completed | [23.timeouts.read.md](23.timeouts.read.md) |
| 24 | timeouts.update | Argument | No | ✅ Completed | [24.timeouts.update.md](24.timeouts.update.md) |

## Notes

1. **Timeouts**: All four timeout fields (create, delete, read, update) are confirmed in the schema definition:
   ```go
   Timeouts: &pluginsdk.ResourceTimeout{
       Create: pluginsdk.DefaultTimeout(30 * time.Minute),
       Read:   pluginsdk.DefaultTimeout(5 * time.Minute),
       Update: pluginsdk.DefaultTimeout(30 * time.Minute),
       Delete: pluginsdk.DefaultTimeout(30 * time.Minute),
   }
   ```

2. **Mutually Exclusive Fields**: `address_prefixes` and `ip_address_pool` are mutually exclusive (ExactlyOneOf constraint)

3. **Nested Blocks**: The `delegation` block contains a nested `service_delegation` block with specific structure

4. **Computed Fields**: `ip_address_pool.allocated_ip_address_prefixes` is computed-only and not included in the task list

5. **Parent Resource**: This is a child resource of `Microsoft.Network/virtualNetworks`, requiring special handling in azapi_resource

6. **Identity**: The resource includes identity schema but it's handled through the SDK helper function
