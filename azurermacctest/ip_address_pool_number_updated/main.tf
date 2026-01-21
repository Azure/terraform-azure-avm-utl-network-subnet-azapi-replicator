terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "azapi" {}

provider "random" {}

resource "random_integer" "number" {
  min = 100000
  max = 999999
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG-n-${random_integer.number.result}"
  location = "eastus"
}

data "azurerm_subscription" "current" {}

resource "azurerm_network_manager" "test" {
  name                = "acctest-nm-ipam-${random_integer.number.result}"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  scope {
    subscription_ids = [data.azurerm_subscription.current.id]
  }
}

resource "azurerm_network_manager_ipam_pool" "test" {
  name               = "acctest-ipampool-${random_integer.number.result}"
  network_manager_id = azurerm_network_manager.test.id
  location           = azurerm_resource_group.test.location
  display_name       = "ipampool1"
  address_prefixes   = ["10.0.0.0/16"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_virtual_network" "test" {
  name                = "acctestvirtnet${random_integer.number.result}"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  ip_address_pool {
    id                     = azurerm_network_manager_ipam_pool.test.id
    number_of_ip_addresses = "65535"
  }
}
