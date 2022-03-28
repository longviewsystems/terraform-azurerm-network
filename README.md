# Solution Description
This solution creates the following:
* A vNet with associated setting like DNS servers
* A variable number of subnets with associated setting like IP address space.
* NSGs attached to subnets with variable rules.
* Optionally, a Resource Group.

# References

* [Azure NSG](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group)
* [Azure Vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
* [Azure Subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)

# Notes

Change variable values under /tf/terraform.tfvars file as needed.

# Usage

To trigger a CI build in Github Actions, submit a PR to the dev/feature branch.

To trigger terratest in the local environment:

```bash
cd test
make azdo-agent-test
```

To deploy to an Azure tenant:

```bash
make azdo-agent
```

To destroy the infra in the Azure tenant:

```bash
cd test
make destroy
```

To cleanup the TF configuration files in your local dev env:

```bash
cd test
make clean
```

---------------

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.88.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.99.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.nsg_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_resource_group.rgrp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Whether to create resource group and use it for all networking resources | `string` | `true` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | List of dns servers to use for virtual network | `list(any)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table' | `string` | `"westeurope"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | A container that holds related resources for an Azure solution | `string` | `"rg-demo-westeurope-01"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | For each subnet, create an object that contain fields | `map(any)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | The address space to be used for the Azure virtual network. | `list(any)` | <pre>[<br>  "10.0.0.0/16"<br>]</pre> | no |
| <a name="input_vnetwork_name"></a> [vnetwork\_name](#input\_vnetwork\_name) | Name of your Azure Virtual Network | `string` | `"vnet-azure-westeurope-001"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_security_group_ids"></a> [network\_security\_group\_ids](#output\_network\_security\_group\_ids) | List of Network security groups and ids |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | The id of the resource group in which resources are created |
| <a name="output_resource_group_location"></a> [resource\_group\_location](#output\_resource\_group\_location) | The location of the resource group in which resources are created |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group in which resources are created |
| <a name="output_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#output\_subnet\_address\_prefixes) | List of address prefix for subnets |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | List of IDs of subnets |
| <a name="output_virtual_network_address_space"></a> [virtual\_network\_address\_space](#output\_virtual\_network\_address\_space) | List of address spaces that are used the virtual network. |
| <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id) | The id of the virtual network |
| <a name="output_virtual_network_name"></a> [virtual\_network\_name](#output\_virtual\_network\_name) | The name of the virtual network |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->



