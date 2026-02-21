# This file configures the AWS providers for the different accounts in the organization.

# IMPORTANT: Before running Terraform, you must manually create IAM roles in the 
# Workload and Logging accounts that the Security account can assume.
# 
# Create these roles MANUALLY in each account (one-time setup):
#
# WORKLOAD ACCOUNT - Create role "cs-admin" with trust to Security account:
#   {
#     "Version": "2012-10-17",
#     "Statement": [{
#       "Effect": "Allow",
#       "Principal": { "AWS": "arn:aws:iam::260998120425:root" },
#       "Action": "sts:AssumeRole"
#     }]
#   }
# Attach AdministratorAccess policy to this role.
#
# LOGGING ACCOUNT - Create role "cs-admin" with same trust policy.
# Attach AdministratorAccess policy to this role.

# The default provider is for the Security account, which is the administrative hub.
# Terraform will use this provider by default.
provider "aws" {
  region = var.region
}

# Provider for the Workload account.
# It assumes a role in the Workload account from the Security account.
provider "aws" {
  alias  = "workload"
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${var.workload_account_id}:role/cs-admin"
    session_name = "Terraform"
  }
}

# Provider for the Logging account.
# It assumes a role in the Logging account from the Security account.
provider "aws" {
  alias  = "logging"
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${var.logging_account_id}:role/cs-admin"
    session_name = "Terraform"
  }
}
