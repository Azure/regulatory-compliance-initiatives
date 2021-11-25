# Use variables to customise the deployment

variable "root_id" {
  type    = string
  default = "banknegara"
}

variable "root_name" {
  type    = string
  default = "Bank Negara Malaysia"
}

variable "deploy_management_resources" {
  type    = bool
  default = true
}

variable "log_retention_in_days" {
  type    = number
  default = 50
}

variable "security_alerts_email_address" {
  type    = string
  default = "my_valid_security_contact@replace_me" # Replace this value with your own email address.
}

variable "management_resources_location" {
  type    = string
  default = "uksouth"
}

variable "management_resources_tags" {
  type = map(string)
  default = {
    demo_type = "deploy_management_resources_custom"
  }
}
# variable "library_path" {
#   type        = string
#   description = "If specified, sets the path to a custom library folder for archetype artefacts."
#   default     = "${path.root}/lib"
# }