resource "azurerm_resource_group" "vnet" {
  name     = var.resource_group_name
  location = var.locations["primary_location"]
  tags     = var.tags
}

module "network" {
  source                   = "../../" #testing root module.
  resource_group_name      = azurerm_resource_group.vnet.name
  vnet_name                = var.vnet_name
  location = var.locations["primary_location"]  
  address_spaces           = var.address_spaces
  subnet_prefixes          = var.subnet_prefixes
  subnet_names             = var.subnet_names
  subnet_service_endpoints = var.subnet_service_endpoints
  tags     = var.tags
}