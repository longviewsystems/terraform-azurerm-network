variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  type        = string
  default     = "rg-demo-westeurope-01"
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  type        = string

}

variable "vnetwork_name" {
  description = "Name of your Azure Virtual Network"
  type        = string

}

variable "vnet_address_space" {
  description = "The address space to be used for the Azure virtual network."
  type        = list(any)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  type = any
  description = "For each subnet, create an object that contain fields"
  default     = {}
}

variable "diagnostic_settings" {
  type = object({
    diagnostics_enabled        = bool
    storage_account_id         = string
    log_analytics_workspace_id = string
    nsg_diag_logs              = list(string)
  })
  description = "Configures Azure Monitor Diagnostic settings for resources in this module.  Toggle feature with diagnostics_enabled (true or false).  Set other values to null to disable."
  default = {
    diagnostics_enabled        = false
    storage_account_id         = null
    log_analytics_workspace_id = null
    nsg_diag_logs              = ["NetworkSecurityGroupEvent", "NetworkSecurityGroupRuleCounter"]
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "dns_servers" {
  description = "List of DNS servers to use for virtual network"
  type        = list(any)
  default     = []
}

variable "log_analytics_workspace_id" {
  description = "Name of the log analytics workspace id"
  type        = string
  default     = ""
}

variable "log_analytics_resource_id" {
  description = "Name of the log analytics resource id"
  type        = string
  default     = ""
}

variable "log_analytics_location" {
  description = "The local of the Log Analytics Workspace.  Leave default value to 'location' specified in location variable. "
  type = string
  default = ""
}

variable "storage_account_id" {
  description = "id of the log analytics storage account id"
  type        = string
  default     = ""
}

variable "la_storage_account_name" {
  description = "Name of the log analytics storage account id"
  type        = string
  default     = ""
}

variable "network_watcher_name" {
  description = "name of the network watcher."
  type        = string
  default     = ""
  
}

variable "nw_resource_group_name" {
  description = "Name of the network watcher resource grp"
  type        = string
  default     = ""
}

variable "create_network_watcher" {
  description = "Name of the network watcher resource grp"
  type        = bool
  default     = false
}
