.ONESHELL:

SHELL := /bin/bash

test:
  go test -timeout 60m

test-build:
	cd /wksp/test/stg1
	terragrunt apply -auto-approve
	cd /wksp/test
	terragrunt run-allapply -auto-approve
clean:
	@find ../ -name terraform.tfstate -type f -exec rm -rf {} +
	@find ../ -name terraform.tfstate.backup -type f -exec rm -rf {} +
	@find ../ -name .terraform -type d -exec rm -rf {} +
	@find ../ -name .terraform.lock.hcl -type f -exec rm -rf {} +
	