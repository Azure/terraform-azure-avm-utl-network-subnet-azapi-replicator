resource "azurerm_subnet" "test" {
  name                 = "acctestsubnet${random_integer.number.result}"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  ip_address_pool {
    id                     = azurerm_network_manager_ipam_pool.test.id
    number_of_ip_addresses = "18446744073709551616"
  }
}
