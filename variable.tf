variable "region" {
    type    = string
    default = "us-east-1"
}

variable "aws_profile" {
    type    = string
    default = "default"
}

variable "launch_role" {
    type    = string
    default = ""
    description = "ARN of AWS IAM Role to use to provision this module"
}

variable "secret_name" {
    type        = string
    default     = "secret_example"
    description = "secret name in aws secrets manager"
}

variable "length" {
    type        = number
    default     = 40
    description = "minimum password length"
}

variable "requirements" {
    type = map(bool) 
    default = {
        upper   = true
        lower   = true
        numbers = true
        special = true
    }
    description = "permit or deny password specifications"
}

variable "override_special" {
    type        = string
    default     = "!@#$%&*()-_=+[]{}<>:?"
    description = "permitted special characters, default is all"
}

variable "recovery_window_in_days" {
    type    = number
    default = 0
    description = "Minimum period days before deletion"
}
