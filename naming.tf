module "naming" {
  #https://registry.terraform.io/modules/Azure/naming/azurerm/latest
  source = "Azure/naming/azurerm"
  suffix = var.naming_suffix
  prefix = var.naming_prefix
}
