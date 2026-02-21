# See variables.tf for descriptions of all input variables.

# Creates a cross-account IAM role that can be assumed by principals in the Security account.
# This role will be created in the Workload and Logging accounts.
resource "aws_iam_role" "cross_account_role" {
  name = var.role_name

  # The assume_role_policy defines who can assume this role.
  # In this case, it allows the root user of the Security account to assume this role,
  # but only if they provide the correct external ID and have MFA enabled.
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_doc.json
}

# Constructs the IAM policy document that defines the trust relationship for the cross-account role.
data "aws_iam_policy_document" "assume_role_policy_doc" {
  statement {
    sid    = "AllowCrossAccountAssumeRole"
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.security_account_id}:root"]
    }

    # The external ID is a secret shared between the accounts to prevent the "confused deputy" problem.
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.external_id]
    }

    # Enforces that the principal assuming the role has authenticated with MFA.
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

# Attaches the specified IAM policy to the cross-account role.
resource "aws_iam_role_policy_attachment" "cross_account_role_policy_attachment" {
  role       = aws_iam_role.cross_account_role.name
  policy_arn = var.policy_arn
}
