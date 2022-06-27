/*****************************************
/*   Route Tables for testing
/*****************************************/

module "test1_routes" {
  source              = "git::https://github.com/longviewsystems/terraform-azurerm-routes.git?ref=1.0.2"
  resource_group_name = azurerm_resource_group.fixture["test1"].name
  location            = azurerm_resource_group.fixture["test1"].location

  route_tables = {
    route_table_default = { # key value for route table
      route_table_name              = "rt-default-01"
      disable_bgp_route_propagation = true
      route_entries = {
        default_route1 = { # key value for routes
          route_name             = "default"
          address_prefix         = "10.0.2.0/24"
          next_hop_type          = "VnetLocal"
          next_hop_in_ip_address = null
        }
        default_route2 = { # key value for routes
          route_name             = "rt-azfw-01"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "Internet"
          next_hop_in_ip_address = null
        }
      }
    }
    route_table_custom = {
      route_table_name              = "rt-custom-01"
      disable_bgp_route_propagation = true
      route_entries = {
        custom_route1 = {
          route_name             = "custom"
          address_prefix         = "10.0.0.16/28"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.0.0.10"
        }
        custom_route2 = {
          route_name             = "AzureFireWall"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "Internet"
          next_hop_in_ip_address = null
        }
      }
    }
  }
}

module "test2_routes" {
  source              = "git::https://github.com/longviewsystems/terraform-azurerm-routes.git?ref=1.0.2"
  resource_group_name = azurerm_resource_group.fixture["test2"].name
  location            = azurerm_resource_group.fixture["test2"].location

  route_tables = {
    route_table_default = { # key value for route table
      route_table_name              = "rt-default-02"
      disable_bgp_route_propagation = true
      route_entries = {
        default_route1 = { # key value for routes
          route_name             = "default"
          address_prefix         = "10.0.2.0/24"
          next_hop_type          = "VnetLocal"
          next_hop_in_ip_address = null
        }
        default_route2 = { # key value for routes
          route_name             = "rt-azfw-02"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "Internet"
          next_hop_in_ip_address = null
        }
      }
    }
    route_table_custom = {
      route_table_name              = "rt-custom-02"
      disable_bgp_route_propagation = true
      route_entries = {
        custom_route1 = {
          route_name             = "custom"
          address_prefix         = "10.0.0.16/28"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.0.0.10"
        }
        custom_route2 = {
          route_name             = "AzureFireWall"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "Internet"
          next_hop_in_ip_address = null
        }
      }
    }
  }
}

# resource "azurerm_route_table" "route_table_test3_default" {
#   name                          = "rt-test3-default"
#   resource_group_name      = azurerm_resource_group.fixture["test3"].name
#   location                 = azurerm_resource_group.fixture["test3"].location
#   disable_bgp_route_propagation = false
#   tags                          = var.tags

#   route {
#     name           = "default"
#     address_prefix = "0.0.0.0/0"
#     next_hop_type  = "VirtualAppliance"
#     next_hop_in_ip_address = "10.1.4.4"
#   }
# }

# resource "azurerm_route_table" "route_table_internet" {
#   name                          = "rt-test3-other"
#   resource_group_name      = azurerm_resource_group.fixture["test3"].name
#   location                 = azurerm_resource_group.fixture["test3"].location

#   disable_bgp_route_propagation = false
#   tags                          = var.tags

#   route {
#     name           = "default"
#     address_prefix = "0.0.0.0/0"
#     next_hop_type  = "Internet"
#   }

#   route {
#     name           = "APIM"
#     address_prefix = "ApiManagement"
#     next_hop_type  = "VnetLocal"
#   }

# }