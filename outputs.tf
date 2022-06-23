output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = element(concat(azurerm_virtual_network.vnet.*.name, [""]), 0)
}

output "virtual_network_id" {
  description = "The id of the virtual network"
  value       = element(concat(azurerm_virtual_network.vnet.*.id, [""]), 0)
}

output "virtual_network_address_space" {
  description = "List of address spaces that are used the virtual network."
  value       = element(coalescelist(azurerm_virtual_network.vnet.*.address_space, [""]), 0)
}

output "subnet_ids" {
  description = "List of IDs of subnets"
  value       = flatten(concat([for s in azurerm_subnet.snet : s.id]))
}

output "network_security_group_ids" {
  description = "List of the Network security groups and ids"
  value       = [for n in azurerm_network_security_group.nsg : n.id]
}

output "subnet_names" {
  description = "List of names of subnets"
  value       = flatten(concat([for s in azurerm_subnet.snet : s.name]))
}

output "route_tables_object" {
  description = "Returns the full object of the created route tables"
  value       = azurerm_route_table.route_table
}
  
# output "all_subnet_output" {
#   description = "List of names of subnets"
#   value       = azurerm_subnet.snet
# }
