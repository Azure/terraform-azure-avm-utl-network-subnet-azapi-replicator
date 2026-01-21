resource "azurerm_subnet" "test" {
  name                 = "acctestsubnet${random_integer.number.result}"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.0.0.0/24", "ace:cab:deca:deed::/64"]
}
