# The AWS Account ID of the centralized Logging account where the S3 bucket will be created.
# This variable is used to construct the S3 bucket name and in the bucket policy.
variable "logging_account_id" {
  description = "The AWS Account ID of the Logging account."
  type        = string
}

# The AWS Account ID of the Workload account, which will be granted permission to write logs
# to the S3 bucket. This is used in the S3 bucket policy.
variable "workload_account_id" {
  description = "The AWS Account ID of the Workload account."
  type        = string
}
