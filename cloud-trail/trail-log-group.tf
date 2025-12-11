locals {
  create_cloudwatch_log_group = var.enabled && var.create_cloudwatch_log_group
}

resource "aws_cloudwatch_log_group" "trail_log_group" {
  count = var.create_cloudwatch_log_group ? 1 : 0

  name = local.trail_log_group_name

  kms_key_id = var.kms_key_arn

  tags = var.tags
}
