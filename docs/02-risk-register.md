# Risk Register

This document tracks potential risks to the project, their impact, likelihood, and mitigation strategies.

| Risk ID | Description                                     | Category     | Likelihood (1-5) | Impact (1-5) | Score (L*I) | Mitigation Strategy                                                                                             | Owner          | Status      |
| :------ | :---------------------------------------------- | :----------- | :--------------- | :----------- | :---------- | :-------------------------------------------------------------------------------------------------------------- | :------------- | :---------- |
| R001    | Over-privileged IAM policies deployed           | Security     | 3                | 5            | 15          | Implement least privilege from the start; conduct thorough policy reviews; use automated policy checkers.       | Security Lead  | Open        |
| R002    | CloudTrail configuration errors, leading to log loss | Operational  | 2                | 5            | 10          | Utilize Terraform for consistent deployment; validate log delivery with test events; monitor S3 bucket for logs. | Operations Lead | Open        |
| R003    | Insecure handling of External ID                | Security     | 2                | 4            | 8           | Generate External ID dynamically with Terraform `random_pet`; store securely (e.g., AWS Secrets Manager if shared between systems, or output to sensitive Terraform variable for human use). | Security Lead  | Open        |
| R004    | Terraform state corruption                      | Operational  | 1                | 4            | 4           | Use remote backend (S3 + DynamoDB locking); enforce `terraform plan` and `apply` via CI/CD.                   | Operations Lead | Open        |
| R005    | Unexpected AWS costs                            | Financial    | 2                | 3            | 6           | Monitor AWS Billing Dashboard; implement S3 lifecycle policies for CloudTrail logs.                             | Finance Team   | Open        |
| R006    | Manual changes overriding IaC                   | Operational  | 3                | 3            | 9           | Implement strong change management; utilize AWS Config to detect drift; educate team on IaC principles.         | Operations Lead | Open        |
| R007    | Failure to meet compliance requirements         | Compliance   | 2                | 4            | 8           | Engage compliance team early; review policies against standards (e.g., CIS Benchmarks).                       | Compliance Lead | Open        |

---
**Key:**
- Likelihood: 1 (Very Low) to 5 (Very High)
- Impact: 1 (Minor) to 5 (Catastrophic)
