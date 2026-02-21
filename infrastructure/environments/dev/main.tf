# This file defines the infrastructure for the 'dev' environment.
# It calls the reusable modules from the `modules` directory and passes
# the environment-specific variables to them.

# Call the s3-logging module to create the centralized logging bucket in the Logging account.
module "s3_logging" {
  source   = "../../modules/s3-logging"
  providers = {
    aws = aws.logging
  }

  logging_account_id  = var.logging_account_id
  workload_account_id = var.workload_account_id
}

# Call the iam-policy module to create the read-only policy in the Security account.
module "read_only_policy" {
  source = "../../modules/iam-policy"
}

# Call the iam-cross-account module to create the cross-account role in the Workload account.
module "iam_cross_account_workload" {
  source   = "../../modules/iam-cross-account"
  providers = {
    aws = aws.workload
  }

  security_account_id = var.security_account_id
  external_id         = var.external_id
  role_name           = "WorkloadReadOnlyRole"
  policy_arn          = module.read_only_policy.policy_arn
}

# Call the iam-cross-account module to create the cross-account role in the Logging account.
module "iam_cross_account_logging" {
  source   = "../../modules/iam-cross-account"
  providers = {
    aws = aws.logging
  }

  security_account_id = var.security_account_id
  external_id         = var.external_id
  role_name           = "LoggingReadOnlyRole"
  policy_arn          = module.read_only_policy.policy_arn
}

# Call the cloudtrail module to create the CloudTrail in the Workload account.
module "cloudtrail" {
  source   = "../../modules/cloudtrail"
  providers = {
    aws = aws.workload
  }

  s3_bucket_name = module.s3_logging.s3_bucket_name
}
