# Architecture: Cloud_secure_IAM

## 1. Project Vision & Scope

This document outlines the architecture for establishing a secure, auditable, and intelligent cross-account IAM solution in AWS, specifically focusing on the foundational security and logging mechanisms. The scope includes:

- Implementing **least-privilege cross-account access** using IAM roles with robust trust policies (MFA, external ID).
- **Centralizing logging** of all access events via AWS CloudTrail.
- Defining all infrastructure as code using **Terraform**.

AI/ML components for anomaly detection are explicitly out of scope for this foundational phase.

## 2. High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          AWS ORGANIZATION / ACCOUNTS                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐        │
│  │  Security Acct  │     │  Workload Acct  │     │  Logging Acct   │        │
│  │  (var.sec_acct) │     │  (var.work_acct)│     │ (var.log_acct)  │        │
│  ├─────────────────┤     ├─────────────────┤     ├─────────────────┤        │
│  │ IAM User/Group  │     │ IAM Role        │     │ Central S3      │        │
│  │ "SecurityAdmin" │────▶│ "SecurityAudit" │     │ (CloudTrail)    │        │
│  │                 │ STS │ (Trust Policy)  │     │                 │        │
│  └─────────────────┘     └─────────────────┘     └────────┬────────┘        │
│                                                           │                   │
│                                                           ▼                   │
│                                                   CloudTrail Logs             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 3. Detailed Component Breakdown

### 3.1 IAM Cross-Account Foundation

-   **Workload Account:**
    -   **IAM Role `SecurityAuditRole`**: This role will be assumed by authorized users/roles from the Security Account.
    -   **Trust Policy**: This policy is crucial for defining *who* can assume the role and *under what conditions*. It will strictly enforce:
        -   `sts:AssumeRole` action.
        -   Principal limited to the Security Account's root ARN or a specific role/user ARN.
        -   `Condition`: `"sts:ExternalId"` matching a unique, secret ID to prevent the "confused deputy" problem.
        -   `Condition`: `"aws:MultiFactorAuthPresent": "true"` to require MFA for assumption.
    -   **Permissions Policy**: A separate, attached policy will grant only least-privilege permissions. For initial setup, this could be `s3:ListBucket` and `s3:GetObject` on a specific, non-sensitive S3 bucket, demonstrating the principle without excessive risk.

-   **Security Account:**
    -   **IAM Group `SecurityOperators`**: A group for administrators who need to assume audit roles across accounts.
    -   **IAM Policy**: Attached to `SecurityOperators`, allowing `sts:AssumeRole` on the `SecurityAuditRole` ARN(s) in the Workload Account(s).
    -   **IAM User (Test User)**: An individual user with MFA enabled, added to `SecurityOperators`, for testing the cross-account assumption process.

### 3.2 Centralized Logging

-   **CloudTrail Configuration:**
    -   **Enabled in all accounts:** AWS CloudTrail will be enabled in all relevant accounts (Security, Workload, and any other accounts within the AWS Organization).
    -   **Management Events:** Will be logged for all API activity.
    -   **Data Events:** (Optional, but recommended for S3/Lambda activity) Can be enabled for specific resources if needed, but consider cost implications.
    -   **Global Service Events:** Will be included.
    -   **Log File Validation:** Enabled to ensure the integrity of log files.
    -   **Delivery to S3:** All CloudTrail logs from all accounts will be delivered to a single, central S3 bucket in a dedicated **Logging Account**.

-   **Logging Account:**
    -   **Central S3 Bucket**: A highly secured S3 bucket (`cloudtrail-logging-bucket-<account_id>-<region>`) with:
        -   **Bucket Policy**: Allows only CloudTrail service to write logs from specified accounts. Prevents unauthorized writes.
        -   **Lifecycle Policies**: To manage log retention (e.g., transition to Glacier, expire after N years).
        -   **Encryption**: Server-Side Encryption with KMS (`SSE-KMS`) or S3-managed keys (`SSE-S3`) for data at rest.
        -   **Versioning**: Enabled to protect against accidental deletion or modification of log files.

### 3.3 Infrastructure as Code (IaC) - Terraform

All components will be defined using Terraform, ensuring consistency, repeatability, and maintainability.

-   **Variables**: All account IDs, resource names, and configurations will be parameterized using Terraform variables.
-   **Modules**: Reusable Terraform modules will encapsulate common patterns (e.g., `iam-cross-account-role`, `cloudtrail-s3-logging-bucket`) to promote modularity and reduce redundancy.
-   **Environments**: Separate Terraform configurations will be maintained for different environments (e.g., `dev`, `prod`) under `infrastructure/environments`.

## 4. Testing & Validation

The following test scenarios will be crucial for validating the setup:

| Test Scenario                                        | Expected Result                                         | Validation Method                 |
| :--------------------------------------------------- | :------------------------------------------------------ | :-------------------------------- |
| Valid role assumption (MFA, correct ExternalId)      | Temporary credentials returned; can perform allowed S3 actions. | AWS CLI `sts assume-role` + `s3 ls`. |
| Assumption without MFA                               | Access denied.                                          | AWS CLI `sts assume-role`.        |
| Assumption with wrong ExternalId                     | Access denied.                                          | AWS CLI `sts assume-role`.        |
| Unauthorized action (e.g., `ec2:DescribeInstances`) | Access denied.                                          | Attempt using assumed role credentials. |
| CloudTrail logs delivered                            | New log files appear in the central S3 bucket.          | S3 console/CLI, check bucket content. |
| Log file integrity                                   | CloudTrail log file validation passes.                  | AWS CLI `cloudtrail validate-logs`. |

## 5. Future Enhancements

-   Integration with a Security Information and Event Management (SIEM) system.
-   Automated alerts for specific security events (e.g., `DeleteUser`, `DisableMfaDevice`).
-   Consideration of AWS Organizations for centralized management of policies and service control policies (SCPs).
-   Re-introduction of AI/ML anomaly detection once this foundation is stable.
