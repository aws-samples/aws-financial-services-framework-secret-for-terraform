# TODO: Prefix enforcement with different policies for prefix
# TODO: Remove default region
# IDEA: Port to Terraform 3.0? Add variable validation

provider "aws" {
  version = "~> 3.4"
  region  = var.region
  profile = "%{if var.aws_profile != ""}${var.aws_profile}%{else}%{endif}"

  dynamic "assume_role" {
    # Only assume a role if one was passed in
    for_each = var.launch_role != "" ? [1] : []
    content {
      role_arn     = var.launch_role
      session_name = "terraform"
      external_id  = "terraform"
    }
  }
}

provider "random" {
  version = "~> 2.2.1"
}

resource "random_password" "password" {
  length           = var.length
  upper            = var.requirements["upper"]
  lower            = var.requirements["lower"]
  number           = var.requirements["numbers"]
  special          = var.requirements["special"]
  override_special = var.override_special
}

resource "aws_secretsmanager_secret" "secret" {
  name                    = var.secret_name
  recovery_window_in_days = var.recovery_window_in_days
  description             = "aws secrets manager secret"
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = random_password.password.result
}
