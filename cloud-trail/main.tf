locals {
  aws_region = data.aws_region.current.name

  resource_name_suffix = "${var.project}-${var.environment}-${local.aws_region}"

  trail_name           = var.trail_name != "" ? var.trail_name : "aws-cloudtrail-trail-${local.resource_name_suffix}"
  trail_bucket_name    = var.s3_bucket_name != "" ? var.s3_bucket_name : local.trail_name
  trail_log_group_name = var.cloudwatch_log_group_name != "" ? var.cloudwatch_log_group_name : local.trail_name
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
