variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type    = string
  default = ""
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
  description = "allow or deny password specifications"
}

variable "override_special" {
  type        = string
  default     = "!@#$%&*()-_=+[]{}<>:?"
  description = "permitted special characters, default is all"
}

variable "recovery_window_in_days" {
  type        = number
  default     = 0
  description = "Minimum period days before deletion"
}