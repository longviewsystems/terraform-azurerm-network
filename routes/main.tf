
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