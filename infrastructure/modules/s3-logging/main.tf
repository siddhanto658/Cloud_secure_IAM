# See variables.tf for descriptions of all input variables.

# Creates a private S3 bucket with default encryption, versioning, and public access blocked.
# This will serve as the immutable logging vault.
resource "aws_s3_bucket" "logging_bucket" {
  bucket = "cloud-secure-iam-logging-bucket-${var.logging_account_id}"

  tags = {
    Name        = "S3 Logging Bucket"
    Project     = "Cloud_Secure_IAM"
    Description = "Immutable S3 bucket for centralized CloudTrail logging."
  }
}

# Configures the S3 bucket to use AWS-managed AES256 encryption by default.
resource "aws_s3_bucket_server_side_encryption_configuration" "logging_bucket_encryption" {
  bucket = aws_s3_bucket.logging_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enables versioning on the S3 bucket to protect against accidental or malicious object deletion.
resource "aws_s3_bucket_versioning" "logging_bucket_versioning" {
  bucket = aws_s3_bucket.logging_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Blocks all public access to the S3 bucket, ensuring logs remain private.
resource "aws_s3_bucket_public_access_block" "logging_bucket_pab" {
  bucket = aws_s3_bucket.logging_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Attaches a resource-based policy to the S3 bucket.
# This policy grants the Workload account permission to write logs and prevents log deletion.
resource "aws_s3_bucket_policy" "logging_bucket_policy" {
  bucket = aws_s3_bucket.logging_bucket.id
  policy = data.aws_iam_policy_document.logging_bucket_policy_doc.json
}

# Constructs the IAM policy document that will be attached to the S3 logging bucket.
# The policy is constructed in-memory and then referenced in the `aws_s3_bucket_policy` resource.
data "aws_iam_policy_document" "logging_bucket_policy_doc" {
  # Statement to allow CloudTrail to check the bucket's existence
  statement {
    sid    = "AllowCloudTrailCheck"
    effect = "Allow"
    actions = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.logging_bucket.arn]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  # Statement to allow the Workload account to write CloudTrail logs.
  statement {
    sid       = "AllowCloudTrailWrites"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logging_bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    # Condition to ensure logs are owned by the Logging account.
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  # Statement to prevent the deletion of log files from any principal.
  statement {
    sid       = "DenyLogDeletion"
    effect    = "Deny"
    actions   = ["s3:DeleteObject"]
    resources = ["${aws_s3_bucket.logging_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
