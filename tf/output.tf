output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.id
}

output "subnets" {
  value = { for subnet in azurerm_subnet.vnet : subnet.name => subnet.id }
}

output "dnszone_vault" {
  value = azurerm_private_dns_zone.dnszone_kvault.id
}

output "dnszone_stblob" {
  value = azurerm_private_dns_zone.dnszone_stblob.id
}

output "dnszone_webapp" {
  value = azurerm_private_dns_zone.dnszone_webapp.id
}










