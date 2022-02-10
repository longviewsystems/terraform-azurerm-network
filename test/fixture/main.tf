data "azurerm_resource_group" "vnet" {
  name     = module.naming.resource_group.name
  location = var.locations["primary_location"]
  tags     = var.tags
}

