#-----------------------------------------------
# Network security group - Default is "false"
#-----------------------------------------------
resource "azurerm_network_security_group" "nsg" {
  for_each = {
    for name, subnets in var.subnets : name => subnets
    if subnets.create_nsg == true
  }
  name                = each.value["nsg_name"]
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = merge({ "ResourceName" = lower("nsg_${each.key}_in") }, var.tags, )
  dynamic "security_rule" {
    for_each = concat(lookup(each.value, "nsg_inbound_rules", []), lookup(each.value, "nsg_outbound_rules", []))
    content {
      name                       = security_rule.value[0] == "" ? "Default_Rule" : security_rule.value[0]
      priority                   = security_rule.value[1]
      direction                  = security_rule.value[2] == "" ? "Inbound" : security_rule.value[2]
      access                     = security_rule.value[3] == "" ? "Allow" : security_rule.value[3]
      protocol                   = security_rule.value[4] == "" ? "Tcp" : security_rule.value[4]
      source_port_range          = "*"
      destination_port_range     = security_rule.value[5] == "" ? "*" : security_rule.value[5]
      source_address_prefix      = security_rule.value[6] == "" ? element(each.value.subnet_address_prefix, 0) : security_rule.value[6]
      destination_address_prefix = security_rule.value[7] == "" ? element(each.value.subnet_address_prefix, 0) : security_rule.value[7]
      description                = "${security_rule.value[2]}_Port_${security_rule.value[5]}"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each = {
    for name, subnets in var.subnets : name => subnets
    if subnets.create_nsg == true
  }
  subnet_id                 = azurerm_subnet.snet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

resource "azurerm_monitor_diagnostic_setting" "nsg" {
  #if var.diagnostic_settings.diagnostics_enabled, then turn on diagnostics. pass empty map which will create no diagnistics settings
  for_each = var.diagnostic_settings.diagnostics_enabled ? azurerm_network_security_group.nsg : {}

  name                       = lower("${each.value.name}-diag")
  target_resource_id         = azurerm_network_security_group.nsg[each.key].id
  storage_account_id         = var.diagnostic_settings.storage_account_id
  log_analytics_workspace_id = var.diagnostic_settings.log_analytics_workspace_id

  dynamic "log" {
    for_each = var.diagnostic_settings.nsg_diag_logs
    content {
      category = log.value
      enabled  = true
      retention_policy {
        enabled = true
        days  = var.diagnostic_settings.retention_policy
      }
    }
  }
}

