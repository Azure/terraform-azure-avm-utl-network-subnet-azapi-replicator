# Test Configuration Functions for azurerm_subnet

## Analysis Summary
**Test Files Analyzed:**
1. `subnet_resource_test.go` - Main test file
2. `subnet_resource_identity_gen_test.go` - Identity test file (no config functions)

**Total Valid Test Cases**: 20

---

## Valid Test Cases

| case name | file url | status | test status |
| ---       | ---      | ---    | ---         |
| basic | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| basic_addressPrefixes | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| complete_addressPrefixes | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| defaultOutbound | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| delegation | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| delegationUpdated | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| ipAddressPool | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| ipAddressPoolVNet | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| ipAddressPoolIPv6 | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| ipAddressPoolNumberUpdated | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| privateEndpointNetworkPolicies | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| enablePrivateLinkServiceNetworkPolicies | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| privateLinkEndpointNetworkPoliciesDefaults | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| serviceEndpoints | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| serviceEndpointsUpdated | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| serviceEndpointPolicyBasic | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| serviceEndpointPolicyUpdate | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| sharingScope | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | invalid |
| updatedAddressPrefix | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| updateServiceDelegation | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |
| updateServiceDelegationNetworkInterfaces | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/network/subnet_resource_test.go | Completed | test success |

---

## Test Cases by Category

### Basic/Foundation Cases (3 cases):
1. **`r.basic(data)`** - Basic subnet with single address prefix
2. **`r.basic_addressPrefixes(data)`** - Basic subnet with IPv4 and IPv6 address space
3. **`r.privateLinkEndpointNetworkPoliciesDefaults(data)`** - Validates default values for private endpoint and private link service network policies

### Address Prefix Configuration (3 cases):
4. **`r.complete_addressPrefixes(data)`** - Subnet with both IPv4 and IPv6 address prefixes
5. **`r.updatedAddressPrefix(data)`** - Tests updating address prefix from 10.0.2.0/24 to 10.0.3.0/24

### Default Outbound Access (1 case):
6. **`r.defaultOutbound(data, enabled)`** - Tests default_outbound_access_enabled with true/false values

### Delegation Features (4 cases):
7. **`r.delegation(data)`** - Subnet with Microsoft.ContainerInstance/containerGroups delegation
8. **`r.delegationUpdated(data)`** - Updated to Microsoft.Databricks/workspaces delegation
9. **`r.updateServiceDelegation(data, serviceName)`** - Tests updating delegation between NGINX, PaloAlto, and Qumulo services
10. **`r.updateServiceDelegationNetworkInterfaces(data, serviceName)`** - Tests Oracle.Database delegation with network interfaces actions

### IP Address Pool Features (4 cases):
11. **`r.ipAddressPool(data)`** - Subnet with IPAM pool (10 IP addresses)
12. **`r.ipAddressPoolVNet(data)`** - Subnet inheriting address from VNet's IPAM pool
13. **`r.ipAddressPoolIPv6(data)`** - Subnet with IPv6 IPAM pool
14. **`r.ipAddressPoolNumberUpdated(data)`** - Tests increasing number_of_ip_addresses from 10 to 50

### Network Policy Features (3 cases):
15. **`r.privateEndpointNetworkPolicies(data, enabled)`** - Tests various private endpoint network policies (Enabled, Disabled, NetworkSecurityGroupEnabled, RouteTableEnabled)
16. **`r.enablePrivateLinkServiceNetworkPolicies(data, enabled)`** - Tests toggling private_link_service_network_policies_enabled

### Service Endpoint Features (4 cases):
17. **`r.serviceEndpoints(data)`** - Subnet with Microsoft.Sql service endpoint
18. **`r.serviceEndpointsUpdated(data)`** - Updated with Microsoft.Sql and Microsoft.Storage endpoints
19. **`r.serviceEndpointPolicyBasic(data)`** - Subnet with service endpoint storage policy resource (no policy attached)
20. **`r.serviceEndpointPolicyUpdate(data)`** - Adds service endpoints and policy to subnet

### Advanced Configuration (1 case):
21. **`r.sharingScope(data)`** - Tests sharing_scope set to "Tenant" with default_outbound_access_enabled=false

---

## Removed Cases

### ❌ Helper/Template Functions:
- **`r.template(data)`** - Helper function providing base infrastructure (resource group + virtual network), never used directly in TestStep

### ❌ Error Test Cases:
- **`r.requiresImport(data)`** - Used with ExpectError to validate import rejection (in TestAccSubnet_requiresImport)
- **Part of `r.ipAddressPoolNumberUpdated(data)` in third step** - The third TestStep uses `r.ipAddressPool(data)` with ExpectError to test validation (decreasing IP addresses not allowed)

### ❌ Test-Only Methods (Not Configuration Functions):
- **`TestAccSubnet_disappears`** - Uses `r.basic` via DisappearsStepData (already counted as basic case)
- Various test methods starting with `testAccSubnet_` (lowercase 't') - These appear to be disabled or draft tests based on lowercase naming convention

---

## Notes

### Configuration Function Patterns:
- Most functions follow pattern: `func (r SubnetResource) functionName(data acceptance.TestData) string`
- Some functions accept additional parameters (e.g., `enabled bool`, `serviceName string`)
- Functions return `fmt.Sprintf(...)` with Terraform HCL configuration

### Test Coverage Areas:
1. **Address Configuration**: Single/multiple prefixes, IPv4/IPv6
2. **Delegation**: Container instances, Databricks, NGINX, PaloAlto, Qumulo, Oracle
3. **Network Policies**: Private endpoints, private link services
4. **Service Endpoints**: SQL, Storage with optional policies
5. **IPAM Integration**: IP address pools at subnet level
6. **Advanced Features**: Sharing scope, default outbound access

### Update Test Patterns:
Several tests validate A → B → A transitions:
- `delegation` → `delegationUpdated` → `basic` → `delegation`
- `serviceEndpoints` → `serviceEndpointsUpdated` → `basic` → `serviceEndpoints`
- `defaultOutbound(true)` → `defaultOutbound(false)`
- `enablePrivateLinkServiceNetworkPolicies(true)` → `(false)` → `(true)`

### Disabled/Draft Tests:
The following test functions use lowercase `testAccSubnet_` (instead of `TestAccSubnet_`) suggesting they are disabled or work-in-progress:
- `testAccSubnet_ipAddressPool`
- `testAccSubnet_ipAddressPoolVNet`
- `testAccSubnet_ipAddressPoolIPv6`
- `testAccSubnet_ipAddressPoolBlockUpdated`
- `testAccSubnet_ipAddressPoolNumberUpdated`

These tests are still valuable for configuration extraction since they contain valid Terraform configurations.

---

## Validation Checklist

- [x] All test files matching `subnet_resource*_test.go` pattern have been identified (2 files found, 0 legacy)
- [x] All test files have been scanned for configuration functions
- [x] All functions used directly in `TestStep.Config` are included
- [x] All functions with `ExpectError` in same TestStep are excluded
- [x] All helper functions (only called by other functions) are excluded
- [x] All `requiresImport` variants are excluded
- [x] Each case has a clear, descriptive label
- [x] Cases are logically categorized
- [x] Total count is accurate (21 distinct configuration functions, 20 valid test cases)
- [x] File source is documented for each test case
