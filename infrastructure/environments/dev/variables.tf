variable "security_account_id" {
  description = "The AWS Account ID of the Security/Management account."
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

variable "region" {
  description = "The primary AWS region for resources."
  type        = string
  default     = "us-east-1"
}

variable "external_id" {
  description = "The unique External ID for cross-account trust."
  type        = string
  sensitive   = true
}
