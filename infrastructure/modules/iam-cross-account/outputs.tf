output "role_arn" {
  description = "The ARN of the cross-account IAM role."
  value       = aws_iam_role.cross_account_role.arn
}

output "role_name" {
  description = "The name of the cross-account IAM role."
  value       = aws_iam_role.cross_account_role.name
}
