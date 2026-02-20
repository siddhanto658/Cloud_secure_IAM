# Project Charter

## 1. Project Title
Cloud_secure_IAM

## 2. Project Manager
[Your Name/Team Lead]

## 3. Project Goal
To establish a secure, auditable, and scalable cross-account IAM solution in AWS, focusing on least-privilege access and centralized CloudTrail logging. This project will be fully defined using Infrastructure as Code (Terraform) and managed via GitHub.

## 4. Objectives
- Implement secure cross-account IAM roles with MFA and External ID requirements.
- Enforce least privilege for all assumed roles.
- Centralize all CloudTrail access logs from participating accounts into a single, secure S3 bucket.
- Define all infrastructure using Terraform.
- Establish a robust GitHub-based project management and CI/CD pipeline for infrastructure changes.

## 5. Scope
### In-Scope
- Terraform for IAM roles, policies, S3 buckets, and CloudTrail configurations.
- Cross-account role assumption from a Security Account to a Workload Account.
- Centralized CloudTrail logging to a Logging Account.
- Initial project management artifacts and GitHub workflows.

### Out-of-Scope (for this phase)
- AI/ML anomaly detection.
- Integration with SIEM systems (e.g., Splunk, ELK).
- Advanced monitoring and alerting beyond basic SNS notifications.
- Cost optimization specific to logging beyond basic S3 lifecycle policies.

## 6. Stakeholders
- **Project Owner:** [Your Name/Department Head]
- **Security Team:** Responsible for defining security policies and auditing.
- **Operations Team:** Responsible for deploying and maintaining the infrastructure.
- **Development Teams:** Users of the Workload Account who will interact with the IAM roles.

## 7. Deliverables
- Fully functional Terraform code for cross-account IAM and centralized logging.
- `README.md` and `ARCHITECTURE.md`.
- Completed project management documentation (`docs/`).
- GitHub Actions workflows for automated Terraform validation.

## 8. Success Criteria
- A user in the Security Account can successfully assume a role in the Workload Account with valid MFA and External ID.
- The assumed role has only the specified least-privilege permissions.
- CloudTrail logs from all configured accounts are successfully delivered to the central S3 bucket.
- All infrastructure is managed by Terraform with a clean `terraform plan` and `terraform apply`.
- All code changes go through a GitHub PR review process with automated checks.

## 9. Budget & Funding
- **Budget:** $0.00
- **Funding Source:** AWS Free Tier usage.
- **Cost Management:** Strict adherence to Free Tier limits (e.g., S3 storage < 5GB, KMS key usage within limits).

## 10. Development Plan & Timeline

**Time Limit:** 2 Weeks (Target Completion: [2 Weeks from Today])

This project follows a 5-stage development cycle:

1.  **Stage 1: Planning (Current Status)**
    - Project Charter, Risk Register, and Initial Architecture.
    - Repository structure and CI/CD baseline.
2.  **Stage 2: Requirements & Analysis**
    - Defining specific cross-account roles and required permissions.
    - Analyzing logging requirements and retention policies.
3.  **Stage 3: Design**
    - Terraform module design for IAM and Logging.
    - Defining state management and backend configuration.
4.  **Stage 4: Implementation & Development**
    - Coding Terraform modules and environment configurations.
    - Developing GitHub Actions for automated linting and planning.
5.  **Stage 5: Testing & Integration**
    - Deployment to test environment.
    - Verification of security constraints (MFA, External ID).
    - Validation of centralized log delivery.

## 11. Key Risks (Initial - to be detailed in Risk Register)
- Incorrect IAM policies leading to over-privilege.
- CloudTrail configuration errors causing log loss.
- Insecure handling of External ID.

---
**Approval:**

[Project Owner Name]
Date: [Current Date]
Signature: _________________________
