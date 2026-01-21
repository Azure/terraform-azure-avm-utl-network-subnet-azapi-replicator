resource "azurerm_subnet" "internal" {
  name                            = "internal"
  resource_group_name             = azurerm_resource_group.test.name
  virtual_network_name            = azurerm_virtual_network.test.name
  address_prefixes                = ["10.0.2.0/24"]
  default_outbound_access_enabled = true
}
