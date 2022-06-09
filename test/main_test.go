package main

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAzDoAgent(t *testing.T) {
	t.Parallel()

	// retryable errors in terraform testing.
	options := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixture",


        Vars: map[string]interface{}{
			expectedSubnet2 := "subnet02",
                        expectedSubnet1 := "subnet01",
                        expectedSubnet3 := "subnet03",


			// We also can see how lists and maps translate between terratest and terraform.
			expectedList2 := []string{expectedSubnet2},
                        expectedList1 := []string{expectedSubnet1},
                        expectedList3 := []string{expectedSubnet3},
		
		},
	})

	defer terraform.Destroy(t, options)
	
	terraform.InitAndApply(t, options)
	
	output := terraform.Output(t, options, "virtual_network_name1")
	assert.Equal(t, "vnet-nsg-assc1", output)
	
	actualSubnetList1 := terraform.OutputList(t, terraformOptions, "subnet_names")
	assert.Equal(t, expectedList1, actualSubnetList1)
	
	// network-test2//
	
	output := terraform.Output(t, options, "virtual_network_name2")
	assert.Equal(t, "vnet-nsg-assc2", output)
	
	actualSubnetList2 := terraform.OutputList(t, terraformOptions, "subnet_names")
	assert.Equal(t, expectedList2, actualSubnetList2)

      	// network-test3//
	
	output := terraform.Output(t, options, "virtual_network_name3")
	assert.Equal(t, "vnet-nsg-assc3", output)
	
	actualSubnetList3 := terraform.OutputList(t, terraformOptions, "subnet_names")
	assert.Equal(t, expectedList3, actualSubnetList3)
	

}
