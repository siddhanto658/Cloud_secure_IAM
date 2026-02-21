# The AWS Account ID of the Security account, which is trusted to assume the cross-account role.
# This is used in the assume role policy document.
variable "security_account_id" {
  description = "The AWS Account ID of the Security account."
  type        = string
}

# The external ID is a secret string used to prevent the "confused deputy" problem.
# It must be provided when assuming the cross-account role.
variable "external_id" {
  description = "The external ID for the cross-account role."
  type        = string
  sensitive   = true
}

variable "role_name" {
  description = "The name of the cross-account IAM role."
  type        = string
  default     = "CrossAccountAdminRole"
}

variable "policy_arn" {
  description = "The ARN of the IAM policy to attach to the cross-account role."
  type        = string
}
