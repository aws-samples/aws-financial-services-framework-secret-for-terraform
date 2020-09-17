data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Default provider - used to create launch role 
provider "aws" {
  version = "~> 3.4"
  region  = var.aws_region
}

# Provider used to provision module with scoped down permissions
provider "aws" {
  version = "~> 3.4"
  region  = var.aws_region
  alias   = "launch"
  assume_role {
      role_arn     = aws_iam_role.test_launch_role.arn
      session_name = "terraform_unit_test"
      external_id  = "terraform"
    }
}


# Create a role with only the permissions needed to instantiate this module
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_iam_role" "test_launch_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Load role policy provided by module developer
data "aws_iam_policy_document" "launch" {
  source_json = file("${path.module}/policy.json")

}

# Associate the policy with the instatiation role
resource "aws_iam_role_policy" "test_policy" {
  role   = aws_iam_role.test_launch_role.id
  policy = data.aws_iam_policy_document.launch.json
}

# Create an instance of the module and pass the desired instantiation role
module "secrets_manager" {
  source                  = "../"
  providers = {
    aws = aws.launch
  }
  length                  = var.length
  requirements            = var.requirements
  override_special        = var.override_special
  recovery_window_in_days = var.recovery_window_in_days
}