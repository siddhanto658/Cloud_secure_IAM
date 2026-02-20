# 1. Trust Policy (Who can assume this role)
data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.trusted_account_id}:root"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.external_id]
    }
    # Enforce MFA for the assumption
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

# 2. The IAM Role
resource "aws_iam_role" "audit_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
}

# 3. Least Privilege Policy (What the role can do)
resource "aws_iam_policy" "audit_policy" {
  name        = "${var.role_name}-Policy"
  description = "Provides limited read-only access for security auditing."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:Get*",
          "iam:List*",
          "ec2:Describe*",
          "s3:GetBucketPolicy",
          "s3:GetBucketLogging",
          "s3:ListAllMyBuckets"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# 4. Attach the policy to the role
resource "aws_iam_role_policy_attachment" "audit_attach" {
  role       = aws_iam_role.audit_role.name
  policy_arn = aws_iam_policy.audit_policy.arn
}

output "role_arn" {
  value = aws_iam_role.audit_role.arn
}
