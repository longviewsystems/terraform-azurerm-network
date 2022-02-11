# Solution Description
This solution creates a resource group and a hub virtual network on Azure with terraform codes.

# References:
* [Azure vnet](https://registry.terraform.io/modules/Azure/network/azurerm/latest)
* [Azure nameing](https://registry.terraform.io/modules/Azure/naming/azurerm/latest)

# Notes
Change variable values under /tf/terraform.tfvars file as needed. 

# Usage
To trigger a CI build in Github Actions, submit a PR to the dev/feature branch.

To trigger terratest in the local environment:
```bash
$ cd test
$ make azdo-agent-test
```

To deploy to an Azure tenant:
```bash
$ make azdo-agent
```

To destroy the infra in the Azure tenant:
```bash
$ cd test
$ make destroy
```

To cleanup the TF configuration files in your local dev env:
```bash
$ cd test
$ make clean
```

-----------