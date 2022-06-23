/*****************************************
/*   Naming conventions
/*****************************************/
locals {
  tests = { "test1" = {}, "test2" = {}, "test3" = {} }
}

#network naming
module "naming" {
  for_each = local.tests
  source   = "Azure/naming/azurerm"
  version  = "0.1.1"
  prefix   = ["mod", each.key]
  # suffix = random_string.random.value

  unique-include-numbers = false
  unique-length          = 4
}

#Shared Services Naming
module "ss_naming" {
  source  = "Azure/naming/azurerm"
  version = "0.1.1"
  prefix  = ["mod", "shared"]
  # suffix = random_string.random.value

  unique-include-numbers = false
  unique-length          = 4
}



/*****************************************
/*   Resource Groups
/*****************************************/

resource "azurerm_resource_group" "fixture" {
  for_each = module.naming
  name     = module.naming[each.key].resource_group.name_unique
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "shared_services" {
  name     = module.ss_naming.resource_group.name_unique
  location = var.location
  tags     = var.tags
}

/*****************************************
/*   Log Analytics
/*****************************************/


#Just create one (test1).
resource "azurerm_log_analytics_workspace" "shared_services" {
  name                = module.ss_naming.log_analytics_workspace.name_unique
  location            = azurerm_resource_group.shared_services.location
  resource_group_name = azurerm_resource_group.shared_services.name
  sku                 = "PerGB2018"
  tags                = var.tags
}


/*****************************************
/*   Storage Account
/*****************************************/

resource "azurerm_storage_account" "shared_services" {
  name                     = module.ss_naming.storage_account.name_unique
  location                 = azurerm_resource_group.shared_services.location
  resource_group_name      = azurerm_resource_group.shared_services.name
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = var.tags
}
