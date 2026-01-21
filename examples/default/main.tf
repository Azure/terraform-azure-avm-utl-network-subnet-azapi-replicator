resource "random_string" "name" {
  length  = 8
  special = false
  upper   = false
}

resource "random_integer" "number" {
  max = 999999
  min = 100000
}

resource "azurerm_resource_group" "test" {
  location = "eastus"
  name     = "acctestRG-${random_integer.number.result}"
}

resource "azurerm_virtual_network" "test" {
  location            = azurerm_resource_group.test.location
  name                = "acctestvirtnet${random_integer.number.result}"
  resource_group_name = azurerm_resource_group.test.name
  address_space       = ["10.0.0.0/16"]
}

module "replicator" {
  source = "../../"

  name               = "internal"
  virtual_network_id = azurerm_virtual_network.test.id
  address_prefixes   = ["10.0.0.0/24"]
  enable_telemetry   = var.enable_telemetry
}

resource "azapi_resource" "this" {
  location                         = module.replicator.azapi_header.location
  name                             = module.replicator.azapi_header.name
  parent_id                        = module.replicator.azapi_header.parent_id
  type                             = module.replicator.azapi_header.type
  body                             = module.replicator.body
  ignore_null_property             = module.replicator.azapi_header.ignore_null_property
  locks                            = module.replicator.locks
  replace_triggers_external_values = module.replicator.replace_triggers_external_values
  retry                            = module.replicator.retry
  schema_validation_enabled        = module.replicator.azapi_header.schema_validation_enabled
  sensitive_body                   = module.replicator.sensitive_body
  sensitive_body_version           = module.replicator.sensitive_body_version
  tags                             = module.replicator.azapi_header.tags

  dynamic "identity" {
    for_each = try(module.replicator.azapi_header.identity != null, false) ? [module.replicator.azapi_header.identity] : []

    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, null)
    }
  }
  dynamic "timeouts" {
    for_each = module.replicator.timeouts != null ? [module.replicator.timeouts] : []

    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }
}

moved {
  from = azurerm_subnet.test
  to   = azapi_resource.this
}
