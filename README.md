# Solution Description
This solution creates the following:
* A vNet with associated setting like DNS servers
* A variable number of subnets with associated setting like IP address space.
* NSGs attached to subnets with variable rules.
* A route table attached to a subnet.
* Optionally, a Resource Group.

# References

* [Azure NSG](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group)
* [Azure Vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
* [Azure Subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
* [Azure Route Table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table)

# Notes

Change variable values under /tf/terraform.tfvars file as needed.

# Usage

```
module "network_test1" {
  source              = "git::https://github.com/longviewsystems/terraform-azurerm-network.git?ref=2.3.0"
  resource_group_name = var.resource_group_name
  vnetwork_name       = "vnet-nsg-assc3"
  location            = var.location
  vnet_address_space  = ["10.1.0.0/16"]
  dns_servers         = ["10.1.1.24"]

  subnets = {
    app-gw = {
      subnet_name                                    = "snet-appgw-01"
      subnet_address_prefix                          = ["10.1.2.0/24"]
      create_nsg                                     = true
      nsg_name                                       = "nsg-appgw-01"
      route_table_rg_name =  var.route_table1.route_table_rg_name
      route_table_name =  var.route_table1.route_table_name
      service_endpoints                              = ["Microsoft.Sql", "Microsoft.Storage"]
      enforce_private_link_endpoint_network_policies = true
      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["AllowAccessToGWM_ProbePorts","110","Inbound","Allow","TCP","65200-65535","GatewayManager","*"],
        ["AllowAccessToInternet_Https","910","Inbound","Allow","TCP","","AzureLoadBalancer","*"],
        ["AllowAccessToAzureLoadBalancer","920","Inbound","Allow","TCP","443","Internet","*"],
        ["DenyAllInternetInbound","4096","Inbound","Deny","*","","Internet","*"]
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["Allow_All", "100", "Outbound", "Allow", "*", "*", "", "*"]
      ]
    }
    app-web = {
      subnet_name                                    = "snet-appweb-01"
      subnet_address_prefix                          = ["10.1.3.0/24"]
      create_nsg                                     = true
      nsg_name                                       = "nsg-appweb-01"
      route_table_rg_name =  var.route_table2.route_table_rg_name
      route_table_name =  var.route_table2.route_table_name
      service_endpoints                              = []
      enforce_private_link_endpoint_network_policies = true
      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["Allow_HTTPS", "100", "Inbound", "Allow", "TCP", "443", "*", "*"],
        ["Allow_HTTP", "110", "Inbound", "Allow", "TCP", "80", "*", ""],
        ["Deny_All", "4096", "Inbound", "Deny", "*", "*", "", "*"],
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["Allow_All", "100", "Outbound", "Allow", "*", "*", "", "*"]
      ]
    }    
    snet-db-01 = {
      subnet_name                                    = "snet-db-01"
      subnet_address_prefix                          = ["10.1.4.0/24"]
      create_nsg                                     = false
      nsg_name                                       = "snet-db-01-nsg"
      route_table_rg_name =  null #var.route_table2.route_table_rg_name
      route_table_name =  null #var.route_table2.route_table_name
      service_endpoints                              = ["Microsoft.Sql"]
      enforce_private_link_endpoint_network_policies = true
      nsg_inbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["Allow_MI_Subnet","100","Inbound","Allow","*","*","10.100.3.128/26","*"],          
        ["Allow_MI_Mgmt","200","Inbound","Allow","TCP","9000, 9003, 1438, 1440, 1452","SqlManagement","*"],
        ["Allow_MI_Mgmt2","300","Inbound","Allow","TCP","9000, 9003","CorpnetSaw","*"],
        ["Allow_MI_Mgmt3","400","Inbound","Allow","TCP","9000, 9003","CorpnetPublic","*"],
        ["Allow_MI_Health_Probe","500","Inbound","Allow","TCP","*","AzureLoadBalancer","*"],
        ["Deny_All_Internet_Inbound","4096","Inbound","Deny","*","","Internet","*"]
      ]

      nsg_outbound_rules = [
        # [name, priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix]
        # To use defaults, use "" without adding any values.
        ["Allow_MI_Mgmt_Outbound", "110", "Outbound", "Allow", "TCP", "*", "*", "AzureCloud"],
        ["Deny_All_Internet_Outbound","4096","Outbound","Deny","*","","Internet","*"]
      ]
    }
  }
}

```

---------------

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.88.1, < 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 2.88.1, < 3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_subnet.snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.nsg_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.routetable](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_route_table.routetable](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/route_table) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings) | Configures Azure Monitor Diagnostic settings for resources in this module.  Toggle feature with diagnostics\_enabled (true or false).  Set other values to null to disable. | <pre>object({<br>    diagnostics_enabled        = bool<br>    storage_account_id         = string<br>    log_analytics_workspace_id = string<br>    nsg_diag_logs              = list(string)<br>    retention_policy           = number<br>  })</pre> | <pre>{<br>  "diagnostics_enabled": false,<br>  "log_analytics_workspace_id": null,<br>  "nsg_diag_logs": [<br>    "NetworkSecurityGroupEvent",<br>    "NetworkSecurityGroupRuleCounter"<br>  ],<br>  "retention_policy": 90,<br>  "storage_account_id": null<br>}</pre> | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | List of DNS servers to use for virtual network | `list(any)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table' | `string` | `"westeurope"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | A container that holds related resources for an Azure solution | `string` | `"rg-demo-westeurope-01"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | For each subnet, create an object that contain fields | `map(any)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | The address space to be used for the Azure virtual network. | `list(any)` | <pre>[<br>  "10.0.0.0/16"<br>]</pre> | no |
| <a name="input_vnetwork_name"></a> [vnetwork\_name](#input\_vnetwork\_name) | Name of your Azure Virtual Network | `string` | `"vnet-azure-westeurope-001"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_security_group_ids"></a> [network\_security\_group\_ids](#output\_network\_security\_group\_ids) | List of the Network security groups and ids |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | List of IDs of subnets |
| <a name="output_subnet_names"></a> [subnet\_names](#output\_subnet\_names) | List of names of subnets |
| <a name="output_virtual_network_address_space"></a> [virtual\_network\_address\_space](#output\_virtual\_network\_address\_space) | List of address spaces that are used the virtual network. |
| <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id) | The id of the virtual network |
| <a name="output_virtual_network_name"></a> [virtual\_network\_name](#output\_virtual\_network\_name) | The name of the virtual network |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->



