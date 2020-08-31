output "secret_arn" {
    value = aws_secretsmanager_secret.secret.arn
}

output "region" {
    value = var.region
}

output "secret_name" {
    value = var.secret_name
}