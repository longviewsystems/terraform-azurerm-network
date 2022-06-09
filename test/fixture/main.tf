#------------------------
# Local declarations
#------------------------

resource "random_string" "random" {
  length  = 4
  special = false
}

locals {
  resource_group_name = "rg-${var.resource_group_name}-${random_string.random.result}"
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
}


data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = local.resource_group_name
}


resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = local.resource_group_name
  location = var.location
  tags     = merge({ "Name" = format("%s", var.resource_group_name) }, var.tags, )
}


module "network" {
  source              = "../.." # testing root module
  vnetwork_name       = var.vnetwork_name
  location            = local.location
  resource_group_name = local.resource_group_name
  vnet_address_space  = var.vnet_address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
  subnets             = var.subnets
}