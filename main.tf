provider "aws" {
    version = "~> 2.0"
    region = var.region
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
    name        = var.secret_name
    recovery_window_in_days = var.recovery_window_in_days
    description = "aws secrets manager secret"
}

resource "aws_secretsmanager_secret_version" "secret_version" {
    secret_id  = aws_secretsmanager_secret.secret.id
    secret_string = random_password.password.result
}
