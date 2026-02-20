variable "trusted_account_id" {
  description = "The AWS Account ID of the account allowed to assume this role."
  type        = string
}

variable "external_id" {
  description = "Unique external ID for the trust relationship."
  type        = string
}

variable "role_name" {
  description = "The name of the IAM role to create."
  type        = string
  default     = "CloudSecure-AuditRole"
}
