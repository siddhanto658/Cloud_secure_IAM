# Cloud Secure IAM

A secure, auditable, and scalable cross-account IAM solution in AWS using Terraform.

## Architecture

This project implements a 3-account AWS security architecture:

| Account | Purpose |
|---------|---------|
| **Security** | Management account - you run Terraform from here |
| **Workload** | Your application resources (EC2, RDS, S3, etc.) |
| **Logging** | Centralized CloudTrail logs in immutable S3 bucket |

### How It Works

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Security   │     │  Workload   │     │  Logging    │
│  (You)      │     │  Account    │     │  Account    │
├─────────────┤     ├─────────────┤     ├─────────────┤
│ Terraform   │────▶│ IAM Role    │     │ S3 Bucket   │
│             │     │ CloudTrail  │────▶│ (logs)       │
│ Read-Only   │◀────│ IAM Role    │     │ IAM Role    │
│ Access      │     │             │     │             │
└─────────────┘     └─────────────┘     └─────────────┘
      │
      │ MFA + External ID
      ▼
  You assume cross-account roles
```

## Features

- **Cross-Account IAM Roles** - Secure access with MFA + External ID
- **Least Privilege** - Read-only access by default
- **Centralized Logging** - All CloudTrail logs in one immutable S3 bucket
- **Infrastructure as Code** - 100% Terraform managed
- **Immutable Bucket** - Denies log deletion

## Prerequisites

- 3 AWS Accounts (Security, Workload, Logging)
- AWS CLI configured with Security account
- Terraform CLI
- MFA enabled on your IAM user

## Quick Start

### 1. Configure Variables

```bash
cd infrastructure/environments/dev
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your account IDs
```

### 2. Create Bootstrap Role

In Workload and Logging accounts, create a role `cs-admin` with:
- Trust to Security account (260998120425)
- AdministratorAccess policy

### 3. Run Terraform

```bash
terraform init
terraform plan
terraform apply
```

### 4. Use Cross-Account Access

```bash
# Assume role with MFA
aws sts assume-role \
  --role-arn "arn:aws:iam::WORKLOAD_ACCOUNT_ID:role/WorkloadReadOnlyRole" \
  --role-session-name "MySession" \
  --external-id "your-external-id" \
  --serial-number "arn:aws:iam::SECURITY_ACCOUNT_ID:mfa/YOUR_USER" \
  --token-code "123456"
```

## Repository Structure

```
Cloud_secure_IAM/
├── infrastructure/
│   ├── environments/
│   │   └── dev/           # Dev environment
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       ├── outputs.tf
│   │       └── providers.tf
│   └── modules/
│       ├── iam-cross-account/    # Cross-account IAM role
│       ├── iam-policy/           # Read-only IAM policy
│       ├── s3-logging/           # Centralized logging bucket
│       └── cloudtrail/           # CloudTrail configuration
├── docs/                  # Project documentation
├── .github/              # CI/CD workflows
└── README.md
```

## Security

- MFA required for cross-account access
- External ID prevents "confused deputy" attacks
- S3 bucket policy denies log deletion
- No credentials hardcoded - uses IAM roles only
- `terraform.tfvars` is gitignored - never commit secrets
