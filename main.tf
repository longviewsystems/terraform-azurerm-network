#-------------------------------------
# VNET Creation - Default is "true"
#-------------------------------------

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnetwork_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_servers         = var.dns_servers
  address_space       = var.vnet_address_space
  tags                = var.tags

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
  service_endpoint_policy_ids                    = null

}

#-----------------------------------------------
#          Route Tables 
#-----------------------------------------------
    
resource "azurerm_route_table" "route_table" {
  for_each = {
    for name, subnets in var.subnets : name => subnets
    if subnets.create_route_table == true
  }
  name                          = each.value.route_table_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation
  tags                          = var.tags
  
  dynamic "route" {
    for_each = each.value.routes
    content {
      name                   = route.value[0] == "" ? "default" : route.value[0]
      address_prefix         = route.value[1] 
      next_hop_type          = route.value[2]
      next_hop_in_ip_address = route.value[3]
    }
  }
}
    
resource "azurerm_subnet_route_table_association" "routetable" {
   for_each = {
    for name, subnets in var.subnets : name => subnets
    if subnets.create_route_table == true
  }
  subnet_id                 = azurerm_subnet.snet[each.key].id
  route_table_id            = azurerm_route_table.route_table[each.key].id
}

#-----------------------------------------------
#          Diagnostic Settings
#-----------------------------------------------
    
# resource "azurerm_monitor_diagnostic_setting" "vnet" {
#   #if var.diagnostic_settings.diagnostics_enabled, then turn on diagnostics. pass empty map which will create no diagnistics settings
  
#   name                       = lower("${azurerm_virtual_network.vnet.name}-diag")
#   target_resource_id         = azurerm_virtual_network.vnet.id
#   storage_account_id         = var.diagnostic_settings.storage_account_id
#   log_analytics_workspace_id = var.diagnostic_settings.log_analytics_workspace_id
  
#   dynamic "log" {
#     for_each = var.diagnostic_settings.vnet_diag_logs
#     content {
#       category = log.value
#       enabled  = true
#     }
#   }
# }