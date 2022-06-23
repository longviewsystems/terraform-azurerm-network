#-------------------------------------
# VNET Creation - Default is "true"
#-------------------------------------

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnetwork_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_servers         = var.dns_servers
  address_space       = var.vnet_address_space
  tags                = merge({ "Name" = format("%s", var.vnetwork_name) }, var.tags, )

}

#--------------------------------------------------------------------------------------------------------
# Subnets Creation with, NSG Association
#--------------------------------------------------------------------------------------------------------


resource "azurerm_subnet" "snet" {
  for_each                                       = var.subnets
  name                                           = each.value.subnet_name
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = each.value.subnet_address_prefix
  service_endpoints                              = lookup(each.value, "service_endpoints", [])
  enforce_private_link_endpoint_network_policies = lookup(each.value, "enforce_private_link_endpoint_network_policies", null)

}

#-----------------------------------------------
#          Route Tables 
#-----------------------------------------------
    
resource "azurerm_route_table" "route_table" {
  for_each                      = var.route_tables
  name                          = each.value.route_table_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation
  tags                          = var.tags
  
  dynamic "route" {
    for_each = each.value.route_entries
    content {
      name                   = route.value.route_name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = contains(keys(route.value), "next_hop_in_ip_address") ? route.value.next_hop_in_ip_address : null
    }
  }
}
    
resource "azurerm_subnet_route_table_association" "routetable" {
   for_each = {
    for name, subnets in var.subnets : name => subnets
    if subnets.route_table_name != ""
  }
  subnet_id                 = azurerm_subnet.snet[each.key].id 
  route_table_id            = azurerm_route_table.route_table[each.value.route_table_name].id

}
