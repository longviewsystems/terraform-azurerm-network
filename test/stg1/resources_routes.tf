/*****************************************
/*   Route Table - test3
/*****************************************/

resource "azurerm_route_table" "route_table_test3_default" {
  name                          = "rt-test3-default"
  resource_group_name      = azurerm_resource_group.fixture["test3"].name
  location                 = azurerm_resource_group.fixture["test3"].location
  disable_bgp_route_propagation = false
  tags                          = var.tags

  route {
    name           = "default"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "10.1.4.4"
  }
}

resource "azurerm_route_table" "route_table_internet" {
  name                          = "rt-test3-other"
  resource_group_name      = azurerm_resource_group.fixture["test3"].name
  location                 = azurerm_resource_group.fixture["test3"].location

  disable_bgp_route_propagation = false
  tags                          = var.tags

  route {
    name           = "default"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }

  route {
    name           = "APIM"
    address_prefix = "ApiManagement"
    next_hop_type  = "VnetLocal"
  }

}