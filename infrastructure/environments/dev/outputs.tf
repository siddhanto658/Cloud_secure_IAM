output "security_account_id" {
  description = "The Security account ID."
  value       = var.security_account_id
}

output "workload_account_id" {
  description = "The Workload account ID."
  value       = var.workload_account_id
}

output "logging_account_id" {
  description = "The Logging account ID."
  value       = var.logging_account_id
}

output "s3_logging_bucket_name" {
  description = "The name of the centralized S3 logging bucket."
  value       = module.s3_logging.s3_bucket_name
}

output "iam_workload_role_arn" {
  description = "The ARN of the cross-account IAM role in the Workload account."
  value       = module.iam_cross_account_workload.role_arn
}

output "iam_logging_role_arn" {
  description = "The ARN of the cross-account IAM role in the Logging account."
  value       = module.iam_cross_account_logging.role_arn
}

output "read_only_policy_arn" {
  description = "The ARN of the read-only IAM policy in the Security account."
  value       = module.read_only_policy.policy_arn
}

output "cloudtrail_arn" {
  description = "The ARN of the CloudTrail in the Workload account."
  value       = module.cloudtrail.trail_arn
}

output "how_to_assume_roles" {
  description = "Instructions for assuming cross-account roles"
  value       = <<-EOT
    To assume the cross-account roles from the Security account, use AWS CLI:

    1. Workload Account:
       aws sts assume-role \
         --role-arn "${module.iam_cross_account_workload.role_arn}" \
         --role-session-name "WorkloadReadSession" \
         --external-id "${var.external_id}" \
         --serial-number "arn:aws:iam::${var.security_account_id}:mfa/YOUR_USERNAME" \
         --token-code YOUR_MFA_CODE

    2. Logging Account:
       aws sts assume-role \
         --role-arn "${module.iam_cross_account_logging.role_arn}" \
         --role-session-name "LoggingReadSession" \
         --external-id "${var.external_id}" \
         --serial-number "arn:aws:iam::${var.security_account_id}:mfa/YOUR_USERNAME" \
         --token-code YOUR_MFA_CODE

    Replace YOUR_USERNAME with your IAM user name and YOUR_MFA_CODE with your MFA token.
  EOT
}
