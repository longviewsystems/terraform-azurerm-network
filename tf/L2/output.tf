output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.id
}

output "subnets" {
  value = { for subnet in azurerm_subnet.vnet : subnet.name => subnet.id }
}












