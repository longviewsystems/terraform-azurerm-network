locals {
  interfaces = {
    nic1 = {
      name = "main"
      ip = "xyz"
      primary = true
    },
    nic2 = {
      name = "admin"
      ip = "zyx"
      primary = false
    }
  }
}

output "filter" {
  value = { for k, v in local.interfaces :  k => v if v.primary == true }
}