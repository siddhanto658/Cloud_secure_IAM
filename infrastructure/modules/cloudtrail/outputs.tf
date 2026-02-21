output "trail_arn" {
  description = "The ARN of the CloudTrail."
  value       = aws_cloudtrail.main.arn
}

output "trail_name" {
  description = "The name of the CloudTrail."
  value       = aws_cloudtrail.main.name
}

output "s3_bucket_name" {
  description = "The S3 bucket name where CloudTrail delivers logs."
  value       = aws_cloudtrail.main.s3_bucket_name
}
