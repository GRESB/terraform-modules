################################################################################################################
# Role to be assumed by AWS CloudTrail when pushing logs to CloudWatch log group
#
# with policies set according to
# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-required-policy-for-cloudwatch-logs.html
################################################################################################################

locals {
  create_cloudwatch_role = var.enabled && (var.create_cloudwatch_role || var.create_cloudwatch_log_group)

  iam_service_role_name          = "aws-cloudtrail-service-${local.resource_name_suffix}"
  iam_service_policy_name_prefix = "aws-cloudtrail-policy-${local.resource_name_suffix}"

  cloudwatch_logs_stream_arn_matcher = "arn:aws:logs:${local.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:${local.trail_log_group_name}:log-stream:${var.cloudwatch_log_stream_prefix}*"
}

resource "aws_iam_role" "aws_cloudtrail" {
  count = local.create_cloudwatch_role ? 1 : 0

  name = local.iam_service_role_name

  assume_role_policy = join("", data.aws_iam_policy_document.aws_cloudtrail_assume_role_policy.*.json)

  tags = var.tags
}

data "aws_iam_policy_document" "aws_cloudtrail_assume_role_policy" {
  count = local.create_cloudwatch_role ? 1 : 0

  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    effect = "Allow"

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "aws_cloudtrail" {
  count = local.create_cloudwatch_role ? 1 : 0

  role       = join("", aws_iam_role.aws_cloudtrail.*.name)
  policy_arn = join("", aws_iam_policy.aws_cloudtrail.*.arn)
}

resource "aws_iam_policy" "aws_cloudtrail" {
  count = local.create_cloudwatch_role ? 1 : 0

  name   = "${local.iam_service_policy_name_prefix}-cloudwatch"
  policy = join("", data.aws_iam_policy_document.aws_cloudtrail.*.json)
}

data "aws_iam_policy_document" "aws_cloudtrail" {
  count = local.create_cloudwatch_role ? 1 : 0

  statement {
    sid = "AWSCloudTrailCreateLogStream"

    effect    = "Allow"
    actions   = ["logs:CreateLogStream"]
    resources = [local.cloudwatch_logs_stream_arn_matcher]
  }

  statement {
    sid       = "AWSCloudTrailPutLogEvents"
    effect    = "Allow"
    actions   = ["logs:PutLogEvents"]
    resources = [local.cloudwatch_logs_stream_arn_matcher]
  }
}
