/*****************************************
/*   Naming conventions
/*****************************************/
locals {
  tests = {"test1" = {}, "test2" = {}, "test3" = {}}
}

module "naming" {
  for_each = local.tests
  source  = "Azure/naming/azurerm"
  version = "0.1.1"
  prefix  = ["mod", each.key]
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

# /*****************************************
# /*   Log Analytics
# /*****************************************/

# resource "azurerm_log_analytics_workspace" "fixture" {
#   name                = module.naming.azurerm_log_analytics_workspace.name_unique
#   location = azurerm_resource_group.fixture.location
#   resource_group_name = azurerm_resource_group.fixture.name
#   sku                 = "PerGB2018"
#   tags     = var.tags
# }