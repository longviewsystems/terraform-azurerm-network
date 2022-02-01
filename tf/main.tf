
resource "azurerm_resource_group" "demo" {
  name     = module.naming.resource_group.name
  location = var.locations["primary_location"]
  tags     = var.tags
}

module "vnet" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.NetworkRG.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24"]
  subnet_names        = ["subnet1", "subnet2"]

  subnet_service_endpoints = {
    "subnet1" : ["Microsoft.AzureActiveDirectory"],
    "subnet2" : ["Microsoft.Storage"]
  }

  tags = var.tags

  depends_on = [azurerm_resource_group.NetworkRG]
}
