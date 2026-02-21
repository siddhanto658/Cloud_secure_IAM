# Creates a CloudTrail trail in the Workload account to log all management events.
# The logs will be delivered to the S3 bucket in the Logging account.
resource "aws_cloudtrail" "main" {
  name                          = "management-trail"
  s3_bucket_name                = var.s3_bucket_name
  is_multi_region_trail         = true
  include_global_service_events = true
}
