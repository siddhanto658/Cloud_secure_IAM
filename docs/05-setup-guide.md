# Setup Guide: Multi-Account AWS Environment

This guide details the manual steps taken to set up the 3-account architecture for Cloud_secure_IAM while maintaining a $0 budget.

## 1. Account Creation (AWS Organizations)
The following accounts were created via the Management (Security) account:
- **Security Account:** Primary administrative hub.
- **Workload Account:** Target environment for resources.
- **Logging Account:** Immutable vault for CloudTrail logs.

## 2. Security Guardrails
- **Root MFA:** Enabled on all accounts.
- **Admin IAM User:** Created in Security Account with MFA.
- **OrganizationAccountAccessRole:** Used for cross-account administration from the Security Account.
- **Zero-Spend Budget:** Configured in the billing dashboard to alert on any costs > $0.00.

## 3. Local Development Setup
1. **Credentials:** Use the Security Account Admin credentials.
2. **Terraform Variables:** 
   - Copy `infrastructure/terraform.tfvars.example` to `infrastructure/terraform.tfvars`.
   - Update with the Account IDs found in the AWS Organizations dashboard.
3. **Switching Roles:** 
   - Use the Console "Switch Role" feature with the Account ID and `OrganizationAccountAccessRole`.
