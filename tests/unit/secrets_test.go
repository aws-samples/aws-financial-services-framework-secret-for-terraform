package test

import (
	"fmt"
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/secretsmanager"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

func TestFsfSecretsExample(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples",
		VarFiles:     []string{"terraform.tfvars"},
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
