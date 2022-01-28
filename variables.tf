variable "name" {
  description = "Name of the spoke virtual network."
}

variable "resource_group_name" {
  description = "Name of resource group to deploy resources in."
  default     = null
}

variable "location" {
  description = "The Azure Region in which to create resource."
}

variable "address_space" {
  description = "The address space that is used the virtual network."
  type        = list(string)
}

variable "diagnostics" {
  description = "Diagnostic settings for those resources that support it. See README.md for details on configuration."
  type        = object({ destination = string, eventhub_name = string, logs = list(string), metrics = list(string) })
  default     = null
}

variable "firewall_ip" {
  description = "Private ip of firewall to route all traffic through."
  default     = null
}

variable "subnets" {
  description = "Subnets to create and their configuration. All values are required, set empty to ignore."
  default     = {}
}

variable "use_remote_gateway" {
  description = "Use remote gateway when peering hub to spoke."
  type        = bool
  default     = true
}

variable "private_dns_link" {
  description = "Private dns link for spoke network."
  type        = object({ resource_group_name = string, zone_name = string })
  default     = null
}

variable "netwatcher" {
  description = "Properties for creating network watcher. If set it will create Network Watcher resource using standard naming standard."
  type        = object({ resource_group_location = string, log_analytics_workspace_id = string })
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}

variable "flowlogs_storage_account" {
}

variable "log_analytics_workspace_id" {
}

variable "log_analytics_resource_id" {
  description = "description"
}


variable "netwatcher_rg" {
  default = "NetworkWatcherRG"
}

variable "netwatcher_name" {
}


variable "nsg_diag_logs" {
  description = "NSG Monitoring Category details for Azure Diagnostic setting"
  default     = ["NetworkSecurityGroupEvent", "NetworkSecurityGroupRuleCounter"]
}