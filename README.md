# Cloud Secure IAM

A secure, auditable, and scalable cross-account IAM solution in AWS.

> **Note**: This project was implemented using AWS Console (GUI). Terraform configuration is included for automated/accelerated deployment if desired.
> 
> **Proof**: See [PROOF.md](PROOF.md) for implementation screenshots and verification.

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

## Implementation Methods

This project can be implemented in two ways:

### Method 1: AWS Console (GUI) - Used for This Project
- Manual setup through AWS Management Console
- No Terraform knowledge required
- Good for learning and understanding AWS services

### Method 2: Terraform (Included)
- Automated Infrastructure as Code
- Faster deployment for production
- Requires Terraform CLI knowledge
- Run: `terraform init && terraform apply`

---

## Quick Start (GUI Method)

### 1. Create AWS Accounts
Create 3 accounts via AWS Organizations:
- Security Account (Management)
- Workload Account (Applications)
- Logging Account (Centralized Logs)

### 2. Configure Security Account
- Create IAM user with MFA enabled
- Create IAM policy: `ReadOnlyAccess1` (S3, RDS, IAM, EC2 read access)

### 3. Configure Workload Account
- Create IAM policy: `ReadOnlyAccess`
- Create role: `WorkloadReadOnlyRole`
  - Trust: Security account
  - Requires MFA: Yes
  - Attach policy: `ReadOnlyAccess`
- Create CloudTrail: `management-trail`
  - Multi-region: Yes
  - S3 Bucket: Point to Logging account bucket

### 4. Configure Logging Account
- Create S3 bucket with versioning & encryption
- Add bucket policy (allow CloudTrail, deny deletion)
- Create role: `LoggingReadOnlyRole`
  - Trust: Security account
  - Requires MFA: Yes
  - Attach policies: ReadOnlyAccess, IAMReadOnlyAccess, AmazonS3ReadOnlyAccess

### 5. Test Cross-Account Access
Switch roles via AWS Console:
- Account: `009850210909`, Role: `WorkloadReadOnlyRole`
- Account: `702175641450`, Role: `LoggingReadOnlyRole`

---

## Terraform Deployment (Optional)

For automated deployment, use the included Terraform configuration:

```bash
cd infrastructure/environments/dev
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your account IDs

terraform init
terraform plan
terraform apply
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

---

## Testing & Verification

> **Proof of Implementation**: See [PROOF.md](PROOF.md) for detailed screenshots and verification.

### Verified Components
| Component | Status |
|-----------|--------|
| Cross-account access (Security → Workload) | ✅ Tested |
| Cross-account access (Security → Logging) | ✅ Tested |
| CloudTrail in Workload account | ✅ Created & Running |
| CloudTrail logs in S3 | ✅ Verified |
| S3 read access via cross-account role | ✅ Working |
| IAM read access via cross-account role | ✅ Working |
| CloudTrail read access | ✅ Working |

### Final Configuration
- **CloudTrail**: `management-trail` (multi-region)
- **S3 Bucket**: `cloud-secure-iam-logging-bucket-702175641450`
- **Log Path**: `AWSLogs/009850210909/CloudTrail/`

### Test Commands (AWS CLI)
```bash
# Test Workload Account access
aws sts assume-role \
  --role-arn "arn:aws:iam::009850210909:role/WorkloadReadOnlyRole" \
  --role-session-name "TestSession" \
  --external-id "cs-secure-access-2026" \
  --serial-number "arn:aws:iam::260998120425:mfa/YOUR_USER" \
  --token-code "123456"

# Test Logging Account access
aws sts assume-role \
  --role-arn "arn:aws:iam::702175641450:role/LoggingReadOnlyRole" \
  --role-session-name "TestSession" \
  --external-id "cs-secure-access-2026" \
  --serial-number "arn:aws:iam::260998120425:mfa/YOUR_USER" \
  --token-code "123456"
```
