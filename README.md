# Project: Cloud_secure_IAM

## 1. Overview

This repository contains the infrastructure-as-code and documentation for a secure, auditable, and scalable cross-account IAM solution in AWS. The primary goal is to establish a foundational security posture by implementing least-privilege access and centralized logging, all managed via Terraform and version control.

This project intentionally omits AI/ML components to focus on the critical, underlying security architecture.

## 2. Project Status & Development Plan

**Current Phase:** Initial Project Planning Phase

This project follows a 5-stage development plan:
1.  **Planning:** Initial scope definition, architecture design, and repository setup (Current).
2.  **Requirements & Analysis:** Finalizing IAM policy requirements and logging specifications.
3.  **Design:** Detailing the Terraform module structure and trust relationship models.
4.  **Implementation & Development:** Writing and refining the Terraform code and GitHub Actions workflows.
5.  **Testing & Integration:** Validation of cross-account access and log centralization in the target AWS environment.

## 3. Core Objectives

- **Secure Cross-Account Access:** Implement IAM roles that can only be assumed by trusted entities from a dedicated security account, enforced with Multi-Factor Authentication (MFA) and a unique External ID.
- **Enforce Least Privilege:** Ensure that assumed roles have the absolute minimum permissions required to perform their tasks (e.g., read-only access to a specific S3 bucket).
- **Centralize Logging:** Consolidate AWS CloudTrail logs from all accounts into a single, immutable S3 bucket located in a dedicated logging account for simplified auditing and monitoring.
- **Infrastructure as Code (IaC):** Define 100% of the cloud infrastructure in Terraform to ensure reproducibility, versioning, and peer review.
- **Automated Validation:** Automatically validate all infrastructure changes via GitHub Actions before they are merged.

## 3. Getting Started

### Prerequisites

- AWS Account(s)
- Terraform CLI
- AWS CLI

### Deployment

1. **Configure AWS Credentials:** Set up your AWS credentials for the deployment.
2. **Navigate to the environment:**
   ```sh
   cd infrastructure/environments/dev
   ```
3. **Initialize Terraform:**
   ```sh
   terraform init
   ```
4. **Review the plan:**
   ```sh
   terraform plan
   ```
5. **Apply the infrastructure:**
   ```sh
   terraform apply
   ```

## 4. Repository Structure

- `README.md`: This file.
- `ARCHITECTURE.md`: Detailed explanation of the technical architecture and data flows.
- `docs/`: Project management artifacts (Charter, Risk Register, etc.).
- `infrastructure/`: All Terraform code.
  - `modules/`: Reusable Terraform modules for components like IAM roles and S3 buckets.
  - `environments/`: Configuration for each deployment environment (e.g., `dev`, `prod`).
- `.github/`: CI/CD workflows and PR templates.
