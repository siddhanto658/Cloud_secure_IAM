terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 1. Security Account Provider (Primary)
provider "aws" {
  alias  = "security"
  region = var.region
}

# 2. Workload Account Provider (Assumed)
provider "aws" {
  alias  = "workload"
  region = var.region
  assume_role {
    role_arn     = "arn:aws:iam::${var.workload_account_id}:role/OrganizationAccountAccessRole"
    session_name = "Terraform-Deployment"
  }
}

# 3. Logging Account Provider (Assumed)
provider "aws" {
  alias  = "logging"
  region = var.region
  assume_role {
    role_arn     = "arn:aws:iam::${var.logging_account_id}:role/OrganizationAccountAccessRole"
    session_name = "Terraform-Deployment"
  }
}
