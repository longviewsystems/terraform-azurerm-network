.ONESHELL:

SHELL := /bin/bash

test:
	cd /wksp/test/stg1
	terragrunt apply -auto-approve
	cd /wksp/test
	terragrunt run-all apply -auto-approve
clean:
	@find ../ -name terraform.tfstate -type f -exec rm -rf {} +
	@find ../ -name terraform.tfstate.backup -type f -exec rm -rf {} +
	@find ../ -name .terraform -type d -exec rm -rf {} +
	@find ../ -name .terraform.lock.hcl -type f -exec rm -rf {} +
	