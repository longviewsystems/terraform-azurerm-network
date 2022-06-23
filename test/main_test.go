package main

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformAzDoAgent(t *testing.T) {
	options := &terraform.Options{
		TerraformBinary: "terragrunt",
		TerraformDir: "/wksp/test",
	}

	//Stage #2 should be destroyed first
	defer terraform.TgDestroyAll(t, options)

	//Stage #2 should be built last.
	terraform.TgApplyAll(t, options)
}
