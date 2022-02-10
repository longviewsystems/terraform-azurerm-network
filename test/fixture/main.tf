resource "azurerm_resource_group" "vnet" {
  name     = var.resource_group_name
  location = var.locations["primary_location"]
  tags     = var.tags
}

module "network" {
  source                   = "../../" #testing root module.
  resource_group_name      = azurerm_resource_group.vnet.name
}