Feature: Secrets manager is contained
	Scenario: When I deploy and aws secret it should have the name I specified
		Given I have aws_secretsmanager_secret defined
		When it has name
