output "region" {
    value = var.region
}

output "secret_name" {
    value = module.secrets_manager.secret_name
}