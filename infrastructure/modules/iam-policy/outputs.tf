output "policy_arn" {
  description = "The ARN of the IAM policy."
  value       = aws_iam_policy.read_only_policy.arn
}
