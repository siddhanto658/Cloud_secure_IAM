# Creates a custom IAM policy with read-only permissions.
resource "aws_iam_policy" "read_only_policy" {
  name        = "ReadOnlyAccess"
  description = "Provides read-only access to all AWS services and resources."

  policy = data.aws_iam_policy_document.read_only_policy_doc.json
}

data "aws_iam_policy_document" "read_only_policy_doc" {
  statement {
    sid    = "ReadOnlyAccess"
    effect = "Allow"
    actions = [
      "iam:Get*",
      "iam:List*",
      "s3:Get*",
      "s3:List*",
      "ec2:Describe*",
      "rds:Describe*",
      # Add other read-only actions for other services as needed
    ]
    resources = ["*"]
  }
}
