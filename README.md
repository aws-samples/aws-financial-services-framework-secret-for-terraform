# terraform-aws-fsf-secrets

This module provisions a secrets manager secret with the kind of defaults that our financial services customers regularly request

### Example usage #1 - generate a random password with specific complexity requirements and store it in a secret

    provider "aws" {
        version = "~> 2.0"
        region  = var.region
    }

    module "secrets_manager" {
        source                  = "github.com/aws-samples/aws-financial-services-framework-secret-for-terraform"
        region                  = "us-east-1"
        secret_name             = "my_random_password"
        length                  = 40
        requirements            = {
            upper   = true
            lower   = true
            numbers = true
            special = true
        }
        override_special        = "!@#$%&*()-_=+[]{}<>:?"
        recovery_window_in_days = 0
    }

### Example usage #2 - store a set of key / value pairs in a secret

    provider "aws" {
        version = "~> 2.0"
        region  = var.region
    }

    module "secrets_manager" {
        source                  = "github.com/aws-samples/aws-financial-services-framework-secret-for-terraform"
        version                 = "0.0.2"
        region                  = "us-east-1"
        secret_name             = "my_secret_values"
        recovery_window_in_days = 0
        secret_values = {
            key1 = "value1"
            key2 = "value2"
        }
    }

# Overview

This guide provides infrastructure and configuration information for using this Terraform module that is part of the Financial Service Framework. This document describes the AWS Financial Service Framework generally, of which this specific project is a part of, and then the Secrets Manager module specifically.

## AWS Financial Services Framework

The AWS Financial Service Framework (FSF) is a collection of software assets and documentation whose purpose it is to accelerate the pace at which financial services customers adopt usage of AWS. This acceleration is a function of providing software assets that instantiate AWS resources with the kind of considerations that are typically asked by customers in financial services. These considerations include for example:

- Isolated VPCs with no internet gateways
- Ubiquitous encryption with KMS CMKs wherever possible
- The least permissive entitlements
- Segregation of duties through IAM

These software assets, some of which are encapsulated by opinionated , some of which instantiate Config Rules or Lambda Functions, are backed by the documentation required to satisfy not just technical questions but also those asked by an organization’s governance, risk, and compliance functions. Examples of the questions the FSF assets are prepared to answer include, for example:

- How do I know which controls are satisfied by this software asset?
- How do I know that this control, which forces ELB access logging, is effective?
- How do the controls listed as part of this installation map to frameworks such as NIST 800-53?

We believe that by producing software assets that achieve an outcome and explain the way in which their construction was decided we can accelerate the customer’s journey to AWS. One of the ways in which FSF accomplishes this is by publishing control design documents. Control design documents describe the logic employed by a particular control. For example, a control whose purpose it is to detect unencrypted kinesis streams, would be accompanied by a control design document that describes the logic of the code and how it makes that determination. This is done so that an auditor can test and then attest to the effectiveness of that control. In this example the document would explain that an auditor could test effectiveness by sampling a random number of kinesis streams, use the logic to make a conclusion as to whether the selected kinesis stream is encrypted, and then compare those conclusions to those that were automatically determined by the installed control for the same set of streams. Should the manual and automatic results be the same the auditor should feel comfortable attesting to the effectiveness of the control.

# AWS FSF: Terraform Modules

The AWS FSF project utilizes Terraform modules to enable organizations to use aws resources that have been well reasoned about.

It is the goal of the FSF project to produce a complete library of Terraform modules whose purpose it is to allow our customers to enable the self-service provisioning of AWS assets by their developers. A fundamental tenet of the AWS FSF project is: customers derive the most value from AWS when developers can create and manage the assets required to build their application without depending on other teams to grant approvals or perform pre-requisite tasks on their behalf. AWS FSF is a mechanism for enabling that in a safe and repeatable way.

The Terraform modules in the AWS FSF project are preconfigured with defaults and constraints that are informed by design considerations typically sought after by our Financial Services customers. This ensures that when your developers provision an AWS FSF Terraform Module, say for example an S3 Bucket, they get a bucket with properties such as:

- No public access
- AWS KMS CMK encryption enabled and required
- No ability to modify bucket policy

# Security

The Secrets Manager module is an opinionated module. This means that settings that are available by directly calling

    resource "aws_secretsmanager_secret" "default" {}

are wrapped and sometimes restricted. We've restricted the allowed values as follows:

- Secret requirements
  - length
  - upper/lower case
  - include numbers
  - etc.

# Pricing

You are responsible for the cost of the AWS services used while running this reference deployment. The costs associate with usage of these services are documented here:

- AWS Secrets Manager pricing [https://aws.amazon.com/secrets-manager/pricing/](https://aws.amazon.com/secrets-manager/pricing/)

# Support

Requests for support should be submitted via git issues.

# Contributions

Contribution guidelines are currently in development. In the meantime requests can be made via git issues.

# License Summary

This sample code is made available under a Apache-2.0 license. See the LICENSE file.
