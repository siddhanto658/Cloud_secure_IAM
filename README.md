# 🔐 Cloud Secure IAM

A production-ready, secure, and auditable cross-account IAM solution in AWS - implementing AWS Well-Architected Framework security best practices.

![AWS](https://img.shields.io/badge/AWS-3_Accounts-orange) ![Status](https://img.shields.io/badge/Status-Complete-green) ![Terraform](https://img.shields.io/badge/Terraform-Included-blue)

---

## 📋 Project Overview

This project demonstrates how to securely manage multiple AWS accounts with:
- **Zero Trust Architecture** - Cross-account access with MFA + External ID
- **Centralized Logging** - All API events captured in immutable S3 bucket
- **Least Privilege** - Read-only access by default
- **Audit Ready** - Complete activity tracking for compliance

### Why This Matters

| Problem | Solution |
|---------|----------|
| Single account = higher risk | 3 separate accounts |
| No visibility into other accounts | Centralized CloudTrail logs |
| Weak access controls | MFA + External ID required |
| No audit trail | Immutable logs with deletion protection |

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          AWS MULTI-ACCOUNT ARCHITECTURE                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐    │
│   │   SECURITY      │      │   WORKLOAD      │      │   LOGGING       │    │
│   │   ACCOUNT       │      │   ACCOUNT       │      │   ACCOUNT       │    │
│   │   260998120425  │      │   009850210909  │      │   702175641450  │    │
│   ├─────────────────┤      ├─────────────────┤      ├─────────────────┤    │
│   │                 │      │                 │      │                 │    │
│   │  IAM User       │─────▶│ IAM Role        │      │ S3 Bucket       │    │
│   │  (with MFA)    │ STS  │ (ReadOnly)      │      │ (CloudTrail)    │    │
│   │                 │      │                 │      │                 │    │
│   │                 │      │ CloudTrail      │─────▶│ Immutable       │    │
│   │                 │      │ (logs all)     │      │ Logs            │    │
│   │                 │      │                 │      │                 │    │
│   │                 │◀─────│ IAM Role        │      │ IAM Role        │    │
│   │                 │      │ (ReadOnly)      │      │ (ReadOnly)      │    │
│   └─────────────────┘      └─────────────────┘      └─────────────────┘    │
│                                                                             │
│   🔒 Security: MFA Required + External ID + Deny Log Deletion               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## ✨ Key Features

- ✅ **Cross-Account IAM Roles** - Secure role assumption with MFA + External ID
- ✅ **Least Privilege Access** - Read-only by default
- ✅ **Centralized Logging** - All CloudTrail logs in one S3 bucket
- ✅ **Immutable Logs** - Bucket policy denies log deletion
- ✅ **Multi-Region** - CloudTrail captures events across all regions
- ✅ **Infrastructure as Code** - Terraform modules included

---

## 📦 What's Included

| Component | Description |
|-----------|-------------|
| `infrastructure/modules/` | Reusable Terraform modules |
| `infrastructure/environments/dev/` | Dev environment configuration |
| `docs/` | Full project documentation |
| `.github/workflows/` | CI/CD pipeline for Terraform |
| `ss/` | Implementation screenshots |

---

## 🚀 Quick Start (Two Ways)

### Option 1: AWS Console (GUI) - How I Built It

```
1. Create 3 AWS Accounts via Organizations
2. Security Account: Create IAM user with MFA
3. Workload Account: Create CloudTrail → Send to Logging S3
4. Logging Account: Create S3 bucket with secure policy
5. Create cross-account roles with MFA + External ID
6. Test cross-account access ✅
```

[See PROOF.md for step-by-step screenshots →](PROOF.md)

### Option 2: Terraform (Automated)

```bash
# Clone and configure
git clone https://github.com/siddhanto658/Cloud_secure_IAM.git
cd Cloud_secure_IAM/infrastructure/environments/dev

# Setup variables
cp terraform.tfvars.example terraform.tfvars
# Edit with your account IDs

# Deploy
terraform init
terraform plan
terraform apply
```

---

## 🔒 Security Implementation

```
Trust Policy Requirements:
├── Principal: Security Account (260998120425)
├── MFA Required: aws:MultiFactorAuthPresent = true
└── External ID: cs-secure-access-2026 (prevents confused deputy)

S3 Bucket Policy:
├── Allow CloudTrail to write logs
├── Allow Security account to read
└── DENY all deletions (immutable)
```

---

## ✅ Testing & Verification

| Test | Result |
|------|--------|
| Cross-account access (Security → Workload) | ✅ Verified |
| Cross-account access (Security → Logging) | ✅ Verified |
| CloudTrail logs in S3 | ✅ Verified |
| MFA authentication | ✅ Working |
| Log immutability | ✅ Deny delete policy active |

### Test Commands

```bash
# Test Workload access
aws sts assume-role \
  --role-arn "arn:aws:iam::009850210909:role/WorkloadReadOnlyRole" \
  --role-session-name "TestSession" \
  --external-id "cs-secure-access-2026" \
  --serial-number "arn:aws:iam::260998120425:mfa/YOUR_USER" \
  --token-code "123456"
```

---

## 📚 Documentation

- [PROOF.md](PROOF.md) - Implementation screenshots & verification
- [ARCHITECTURE.md](ARCHITECTURE.md) - Detailed architecture design
- [docs/05-setup-guide.md](docs/05-setup-guide.md) - Step-by-step guide
- [docs/01-project-charter.md](docs/01-project-charter.md) - Project planning

---

## 🎓 What I Learned

1. **AWS Organizations** - Managing multiple accounts
2. **IAM Cross-Account Roles** - Secure role assumption with conditions
3. **CloudTrail** - API activity logging across accounts
4. **S3 Bucket Policies** - Fine-grained access control
5. **Security Best Practices** - MFA, External ID, least privilege
6. **Terraform** - Infrastructure as Code (modules & environments)

---

## 📊 Final Configuration

| Resource | Value |
|----------|-------|
| CloudTrail | `management-trail` (multi-region) |
| S3 Bucket | `cloud-secure-iam-logging-bucket-702175641450` |
| Log Location | `AWSLogs/009850210909/CloudTrail/` |
| Region | `ap-south-1` |
| External ID | `cs-secure-access-2026` |

---

## 🤝 Connect

- **GitHub**: [github.com/siddhanto658](https://github.com/siddhanto658)
- **Project URL**: [github.com/siddhanto658/Cloud_secure_IAM](https://github.com/siddhanto658/Cloud_secure_IAM)

---

*Last Updated: February 2026*
