variable "location" {
  type        = string
  description = "Location used to deploy the resources"
  default     = "westus2"
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  type        = string
}

variable "tags" {
  type        = map(any)
  description = "Resource tags"
  default = {
    environment = "test"
    managed_by  = "terratest"
  }
}

variable "storage_account_id" {
  type = string
  description = "Storage account for Diagnostic logging."
}
  
variable "log_analytics_workspace_id" {
  type = string
  description = "Log Analytics Workspace id to be used for Diagnostic Logging."
}

variable "la_storage_account_name" {
  description = "Name of the log analytics storage account id"
  type        = string
  default     = ""
}

variable "log_analytics_resource_id" {
  description = "Name of the log analytics resource id"
  type        = string
  default     = ""
}

variable "network_watcher_name" {
  description = "name of the network watcher."
  type        = string
  default     = "NetworkWatcher_westus2"
  
}

variable "nw_resource_group_name" {
  description = "Name of the network watcher resource grp"
  type        = string
  default     = "NetworkWatcherRG"
}

variable "create_network_watcher" {
  description = "whether to create network watcher or not"
  type        = bool
  default     = true
  
}
