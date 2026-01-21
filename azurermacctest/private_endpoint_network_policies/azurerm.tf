resource "azurerm_subnet" "test" {
  name                              = "internal"
  resource_group_name               = azurerm_virtual_network.test.resource_group_name
  virtual_network_name              = azurerm_virtual_network.test.name
  address_prefixes                  = azurerm_virtual_network.test.address_space
  private_endpoint_network_policies = "Enabled"
}
