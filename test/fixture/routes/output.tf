output "route_tables_object" {
  description = "Returns the full object of the created route tables"
  value       = azurerm_route_table.route_table
}

output "route_ids" {
  description = "Returns the ID of the created route table"
  value = [
    for route_table in azurerm_route_table.route_table : route_table.id
  ]
}

output "route_table_names" {
  description = "Returns the name of the created route tables"
  value = [
    for route_table in azurerm_route_table.route_table : route_table.name
  ]
}

output "default_route_table_id" {
  description = "Return default route table ID's created"
  value = [
    for route_table in azurerm_route_table.route_table : route_table.id
    if lookup(route_table, "name", "default") == "default"
  ]
}

output "custom_route_table_id" {
  description = "Return custom route table ID's created"
  value = [
    for route_table in azurerm_route_table.route_table : route_table.id
    if lookup(route_table, "name", "default") != "default"
  ]
}