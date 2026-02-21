variable "region" {
  description = "The AWS region to deploy resources to."
  type        = string
  default     = "ap-south-1"
}

variable "security_account_id" {
  description = "The AWS Account ID of the Security account."
  type        = string
}

variable "workload_account_id" {
  description = "The AWS Account ID of the Workload account."
  type        = string
}

variable "logging_account_id" {
  description = "The AWS Account ID of the Logging account."
  type        = string
}

variable "external_id" {
  description = "The external ID for cross-account role assumption."
  type        = string
  sensitive   = true
}
