package test

import (
	"fmt"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/secretsmanager"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

func TestFsfSecretsExample(t *testing.T) {

	maxTerraformRetries := 3
	sleepBetweenTerraformRetries := 5 * time.Second
	retryableTerraformErrors := map[string]string{
		// `terraform apply` frequently fails in CI due to newly created launch role not being available.
		".*AccessDeniedException*":     "Failed to assume launch role.",
		".*not authorized to perform*": "Failed to assume launch role.",
		".*cannot be assumed*":         "Failed to assume launch role.",
	}

	terraformOptions := &terraform.Options{
		TerraformDir:             "../../examples",
		VarFiles:                 []string{"terraform.tfvars"},
		RetryableTerraformErrors: retryableTerraformErrors,
		MaxRetries:               maxTerraformRetries,
		TimeBetweenRetries:       sleepBetweenTerraformRetries,
	}

	defer test_structure.RunTestStage(t, "Teardown", func() {
		terraform.Destroy(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "Init and Deploy", func() {
		terraform.InitAndApply(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "test_name", func() {
		awsRegion := terraform.Output(t, terraformOptions, "region")
		sess := session.Must(session.NewSessionWithOptions(session.Options{
			SharedConfigState: session.SharedConfigEnable,
			Config:            aws.Config{Region: aws.String(awsRegion)},
		},
		))

		secretName := terraform.Output(t, terraformOptions, "secret_name")
		svc := secretsmanager.New(sess)
		input := &secretsmanager.DescribeSecretInput{
			SecretId: aws.String(secretName),
		}

		result, err := svc.DescribeSecret(input)
		if err != nil {
			if aerr, ok := err.(awserr.Error); ok {
				switch aerr.Code() {
				case secretsmanager.ErrCodeResourceNotFoundException:
					fmt.Println(secretsmanager.ErrCodeResourceNotFoundException, aerr.Error())
				case secretsmanager.ErrCodeInternalServiceError:
					fmt.Println(secretsmanager.ErrCodeInternalServiceError, aerr.Error())
				default:
					fmt.Println(aerr.Error())
				}
			} else {
				// Print the error, cast err to awserr.Error to get the Code and
				// Message from an error.
				fmt.Println(err.Error())
			}
		}
		assert.Equal(t, *result.Name, secretName, "These names should match.")
	})
}
