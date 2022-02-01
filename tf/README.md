# Solution Description
This solution under L2 foler creates a resource group and a virtual network with terraform codes.

## Solution Notes:
* Az foundation solution L0(create storage account, etc for terraform state repository) is required for this solution. 

# References:
* [Azure vnet](https://registry.terraform.io/modules/Azure/vnet/azurerm/latest)
* [Azure nameing](https://registry.terraform.io/modules/Azure/naming/azurerm/latest)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.8 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.87.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.92.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_naming"></a> [naming](#module\_naming) | Azure/naming/azurerm | n/a |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | Azure/vnet/azurerm | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.NetworkRG](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_locations"></a> [locations](#input\_locations) | The location of the resources. | `map(string)` | n/a | yes |
| <a name="input_naming_prefix"></a> [naming\_prefix](#input\_naming\_prefix) | The prefix for the names of the resources.  Use only lowercase characters.  Each item will be seperated by a dash. | `list(any)` | n/a | yes |
| <a name="input_naming_suffix"></a> [naming\_suffix](#input\_naming\_suffix) | The suffixes for the names of the resources.  Use only lowercase characters.  Each item will be seperated by a dash. | `list(any)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources created. | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->