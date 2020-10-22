# Needed for terratest to create session in appropriate region
output "aws_region" {
  value = var.aws_region
}

output "secret_name" {
  value = module.secrets_manager.secret_name
}

output "secret_arn" {
  description = "The arn of the secret."
  value       = module.secrets_manager.secret_arn
}


output "secret_version_arn" {
  description = "The ARN of the secret version."
  value       = module.secrets_manager.secret_version_arn
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "launch_role_arn" {
  value = aws_iam_role.test_launch_role.arn
}