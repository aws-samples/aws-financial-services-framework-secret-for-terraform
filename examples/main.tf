provider "aws" {
    version = "~> 2.0"
    region  = var.region
}

module "secrets_manager" {
    source                  = "../"
    region                  = var.region
    length                  = var.length
    requirements            = var.requirements
    override_special        = var.override_special
    recovery_window_in_days = var.recovery_window_in_days
}