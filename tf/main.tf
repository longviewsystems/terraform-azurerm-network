resource "azurerm_resource_group" "example" {
  name     = module.naming.resource_group.name
  location = var.locations["primary_location"]
  tags     = var.tags
}