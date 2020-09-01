output "region" {
    description = "The region where secret exists."
    value = var.region
}

output "secret_arn" {
    description = "The arn of the secret."
    value = aws_secretsmanager_secret.secret.arn
}

output "secret_name" {
    description = "The friendly name of the secret."
    value = var.secret_name
}

output "secret_version_id" {
    description = "The unique identifier of the version of the secret."
    value = aws_secretsmanager_secret_version.secret_version.version_id
}

output "secret_version_arn" {
    description = "The ARN of the secret version."
    value = aws_secretsmanager_secret_version.secret_version.arn
}

