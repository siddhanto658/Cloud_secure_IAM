# Cloud Secure IAM - Project Progress Log

## Overview
A secure, auditable, and scalable cross-account IAM solution in AWS using Terraform (later switched to manual GUI setup).

## Account IDs
| Account | ID | Purpose |
|---------|-----|---------|
| Security | 260998120425 | Management account - run Terraform from here |
| Workload | 009850210909 | Application resources (EC2, RDS, S3, etc.) |
| Logging | 702175641450 | Centralized CloudTrail logs in immutable S3 bucket |

## Configuration
- **Region**: ap-south-1
- **External ID**: cs-secure-access-2026

---

## Completed Steps

### Part 1: Security Account (260998120425)
- ✅ Created IAM Policy: `ReadOnlyAccess1` (read-only access to s3, rds, iam, ec2)

### Part 2: Workload Account (009850210909)
- ✅ Created Read-Only Policy: `ReadOnlyAccess` (visual editor - all services read)
- ✅ Created Cross-Account Role: `WorkloadReadOnlyRole`
  - Trust: Security account (260998120425)
  - Requires MFA: Yes
  - External ID: cs-secure-access-2026
  - Attached Policy: ReadOnlyAccess
- ✅ Edited Trust Policy (manual JSON)
- ✅ Created CloudTrail: `management-trail`
  - Multi-region: Yes
  - S3 Bucket: cloud-secure-iam-logging-bucket-702175641450 (in Logging account)

### Part 3: Logging Account (702175641450)
- ✅ Created S3 Bucket: `cloud-secure-iam-logging-bucket-702175641450`
  - Region: ap-south-1
  - Server-side encryption: AES-256
  - Versioning: Enabled
  - Block public access: Disabled (all unchecked)
- ✅ Added Bucket Policy (updated with 5 statements):
  - AllowCloudTrailCheck: s3:GetBucketAcl
  - AllowCloudTrailWrites: s3:PutObject with bucket-owner-full-control condition
  - AllowListBucket: s3:ListBucket for CloudTrail
  - AllowSecurityAccountRead: s3:ListBucket + s3:GetObject for Security account
  - DenyLogDeletion: Denies s3:DeleteObject for all principals
- ✅ Created Cross-Account Role: `LoggingReadOnlyRole`
  - Trust: Security account (260998120425)
  - Requires MFA: Yes
  - External ID: cs-secure-access-2026
- ✅ Edited Trust Policy (manual JSON)

---

## GitHub Repository
- URL: https://github.com/siddhanto658/Cloud_secure_IAM
- Current branch: main

### Local Changes Made to Repo
1. Moved terraform.tfvars.example from infrastructure/ to infrastructure/environments/dev/
2. Fixed outputs.tf - added sensitive = true to how_to_assume_roles output
3. Commits pushed to remote

---

## Terraform (Not Used - Switched to GUI)
- Terraform was installed but encountered issues:
  - Provider configuration errors (undefined providers in modules)
  - Trust policy issues (cs-admin role not configured correctly)
- Decision: Switched to manual GUI setup instead

---

## Next Steps (Completed)
1. ✅ Test cross-account access from Security → Workload account - PASSED
2. ✅ Test cross-account access from Security → Logging account - PASSED
3. ✅ Verify CloudTrail logs appearing in S3 bucket - VERIFIED
4. ✅ Optional: Clean up unused Terraform files in repo - Skipped (GUI setup)

---

## Commands for Testing Cross-Account Access

### From Security Account (use AWS CLI):
```bash
# Test Workload Account access
aws sts assume-role \
  --role-arn "arn:aws:iam::009850210909:role/WorkloadReadOnlyRole" \
  --role-session-name "TestSession" \
  --external-id "cs-secure-access-2026" \
  --serial-number "arn:aws:iam::260998120425:mfa/YOUR_MFA_USERNAME" \
  --token-code "YOUR_MFA_CODE"

# Test Logging Account access
aws sts assume-role \
  --role-arn "arn:aws:iam::702175641450:role/LoggingReadOnlyRole" \
  --role-session-name "TestSession" \
  --external-id "cs-secure-access-2026" \
  --serial-number "arn:aws:iam::260998120425:mfa/YOUR_MFA_USERNAME" \
  --token-code "YOUR_MFA_CODE"
```

---

## Testing Results (2026-02-23)

### Cross-Account Access Tests
- ✅ Security → Workload: Successfully assumed WorkloadReadOnlyRole via Console
- ✅ Security → Logging: Successfully assumed LoggingReadOnlyRole via Console

### CloudTrail Verification
- ✅ Logs visible in S3 bucket: cloud-secure-iam-logging-bucket-702175641450
- ✅ Log path: AWSLogs/009850210909/ (Workload account events)

### Permissions Attached to Roles
**WorkloadReadOnlyRole:**
- AmazonS3ReadOnlyAccess
- IAMReadOnlyAccess
- AWSCloudTrail_ReadOnlyAccess
- ReadOnlyAccess1

**LoggingReadOnlyRole:**
- AmazonS3ReadOnlyAccess
- IAMReadOnlyAccess
- ReadOnlyAccess

### CloudTrail Final Status
- Trail Name: `management-trail`
- Status: Active & Logging
- Multi-region: Yes
- Logs Location: `s3://cloud-secure-iam-logging-bucket-702175641450/AWSLogs/009850210909/`

---

## Notes
- MFA must be enabled on the IAM user in Security account
- External ID prevents "confused deputy" attacks
- S3 bucket policy denies log deletion for security

---

*Last Updated: 2026-02-23*
