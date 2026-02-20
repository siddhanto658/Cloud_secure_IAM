# Design Document: Cloud_secure_IAM

## 1. Directory Structure
We will use a modular approach to keep the code DRY (Don't Repeat Yourself).

```text
infrastructure/
├── environments/
│   └── dev/                # Where we run "terraform apply"
│       ├── main.tf         # Calls the modules
│       ├── providers.tf    # Configures 3 AWS providers
│       └── variables.tf
└── modules/
    ├── iam-cross-account/  # Creates roles & trust policies
    └── s3-logging/         # Creates the secure log bucket
```

## 2. Multi-Provider Strategy
The `dev/providers.tf` will define three distinct aliases:
- `aws.security` (default)
- `aws.workload` (via assume_role)
- `aws.logging` (via assume_role)

## 3. Terraform State Management
For this phase, we will use a **Local Backend** with the state file stored in your `Cloud_secure_IAM` directory (and ignored by Git). 
*Note: In a production environment, we would use an S3 bucket for state, but local is safer for a $0 budget start.*

## 4. Module Inputs/Outputs
- **IAM Module:** 
  - Input: `trusted_account_id`, `external_id`.
  - Output: `role_arn`.
- **Logging Module:**
  - Input: `workload_account_id`.
  - Output: `bucket_name`, `bucket_arn`.
