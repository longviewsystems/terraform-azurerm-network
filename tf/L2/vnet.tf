
#
# Hub VNet
#

resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

#
# Hub subnets
#

resource "azurerm_subnet" "vnet" {
  for_each = local.subnets_map

  name                                           = each.key
  resource_group_name                            = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = each.value.address_prefix
  enforce_private_link_endpoint_network_policies = each.value.enforce_private_link_endpoint_network_policies
  enforce_private_link_service_network_policies  = each.value.enforce_private_link_service_network_policies
  service_endpoints                              = each.value.service_endpoints

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", {}) != {} ? [1] : []
    content {
      name = lookup(each.value.delegation, "name", null)
      service_delegation {
        name    = lookup(each.value.delegation.service_delegation, "name", null)
        actions = lookup(each.value.delegation.service_delegation, "actions", null)
      }
    }
  }
}


resource "azurerm_route_table" "vnet" {
  name                          = "${var.name}-rt"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = true

  route {
    name                   = "rt-internet-fw"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_ip
  }

  route {
    name                   = "rt-dev-fw"
    address_prefix         = "10.0.0.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_ip
  }
  tags = var.tags

}

resource "azurerm_subnet_route_table_association" "vnet" {
  for_each = local.subnets_with_routes

  subnet_id      = azurerm_subnet.vnet[each.key].id
  route_table_id = azurerm_route_table.vnet.id
}
