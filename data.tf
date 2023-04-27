
# data "azurerm_route_table" "routetable" {
#   for_each            = local.route_table_list
#   name                = local.route_table_list[each.key].route_table_name
#   resource_group_name = local.route_table_list[each.key].route_table_rg_name
# }

