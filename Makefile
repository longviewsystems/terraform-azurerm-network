.ONESHELL:

SHELL := /bin/bash

clean-all: tf-clean tg-clean ##@Helper Cleans up both terraform and terragrunt files.

tg-clean:  ##@Helper Cleans up terragrunt files.
	find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;

tf-clean: ##@Helper Cleans up terraform files.
	@find . -name terraform.tfstate -type f -exec rm -rf {} +
	@find . -name terraform.tfstate.backup -type f -exec rm -rf {} +
	@find . -name .terraform -type d -exec rm -rf {} +  
	@find . -name .terraform.lock.hcl -type f -exec rm -rf {} +
	@find . -name providers -type d -exec rm -rf {} +
	