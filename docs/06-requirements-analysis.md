# Requirements & Analysis: Cloud_secure_IAM

## 1. Permission Matrix (Least Privilege)
The `SecurityAuditRole` in the **Workload Account** will be restricted to the following actions only:

### A. Identity Auditing (IAM)
- `iam:Get*`
- `iam:List*`
- *Purpose: To verify that users and roles in the workload account are properly configured.*

### B. Network & Infrastructure Auditing (EC2)
- `ec2:DescribeSecurityGroups`
- `ec2:DescribeInstances`
- `ec2:DescribeVpcs`
- *Purpose: To ensure no security groups are open to `0.0.0.0/0`.*

### C. Storage Auditing (S3)
- `s3:GetBucketPolicy`
- `s3:GetBucketLogging`
- `s3:ListAllMyBuckets`
- *Purpose: To verify buckets are encrypted and not public.*

## 2. Trust Relationship Requirements
To assume this role from the **Security Account**, the following conditions **MUST** be met:
1. **MFA:** The user must have authenticated with Multi-Factor Authentication.
2. **External ID:** A unique, non-guessable ID must be provided by the caller (prevents Confused Deputy).
3. **Source IP (Optional):** Can be restricted to your corporate/home IP for extra security.

## 3. Logging Requirements (Logging Account)
- **Immutability:** S3 Object Lock or a strict "Deny Delete" bucket policy.
- **Retention:** 90 Days (to stay within Free Tier storage limits).
- **Encryption:** AES-256 (SSE-S3) for $0 cost.

## 4. Constraint Analysis
- **Cost:** All selected services (IAM, S3, CloudTrail) have a Free Tier usage limit. We must monitor S3 "Put" requests as CloudTrail writes frequently.
- **Complexity:** Managing three provider blocks in Terraform to handle the different accounts.
