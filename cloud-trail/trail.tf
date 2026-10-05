locals {
  create_trail = var.enabled && var.create_trail

  cloudwatch_logs_group_arn = var.cloudwatch_log_group_arn != "" ? var.cloudwatch_log_group_arn : join("", aws_cloudwatch_log_group.trail_log_group.*.arn)
  cloudwatch_role_arn       = var.cloudwatch_role_arn != "" ? var.cloudwatch_role_arn : join("", aws_iam_role.aws_cloudtrail.*.arn)
}

resource "aws_cloudtrail" "default" {
  count = local.create_trail ? 1 : 0

  name = local.trail_name

  s3_bucket_name             = local.trail_bucket_name
  s3_key_prefix              = var.s3_bucket_object_prefix
  cloud_watch_logs_group_arn = local.cloudwatch_logs_group_arn
  cloud_watch_logs_role_arn  = local.cloudwatch_role_arn
  kms_key_id                 = var.kms_key_arn

  enable_logging                = var.enable_logging
  enable_log_file_validation    = var.enable_log_file_validation
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail         = var.is_multi_region_trail
  is_organization_trail         = var.is_organization_trail

  dynamic "event_selector" {
    for_each = var.event_selector

    content {
      include_management_events = lookup(event_selector.value, "include_management_events", null)
      read_write_type           = lookup(event_selector.value, "read_write_type", null)

      dynamic "data_resource" {
        for_each = lookup(event_selector.value, "data_resource", [])

        content {
          type   = data_resource.value.type
          values = data_resource.value.values
        }
      }
    }
  }

  dynamic "advanced_event_selector" {
    for_each = var.advanced_event_selector

    content {
      name = advanced_event_selector.value.name

      dynamic "field_selector" {
        for_each = advanced_event_selector.value.field_selector

        content {
          field           = field_selector.value.field
          equals          = field_selector.value.equals
          not_equals      = field_selector.value.not_equals
          starts_with     = field_selector.value.starts_with
          not_starts_with = field_selector.value.not_starts_with
          ends_with       = field_selector.value.ends_with
          not_ends_with   = field_selector.value.not_ends_with
        }
      }
    }
  }

  tags = var.tags

  depends_on = [
    aws_s3_bucket.trail_bucket, # local variable with bucket name does not depend on resource, so we add an explicit dependency
  ]
}
