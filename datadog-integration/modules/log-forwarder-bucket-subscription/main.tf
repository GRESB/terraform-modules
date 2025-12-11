locals {
  subscription_kms_keys = { for name, info in var.subscriptions : name => info.kms_key_arn if info.is_encrypted }
}

#############################
# Bucket
#############################
resource "aws_s3_bucket_notification" "bucket_subscription" {
  for_each = var.subscriptions

  bucket = try(reverse(split(":", each.value.bucket_arn))[0], "") # Get bucket name from ARN

  lambda_function {
    lambda_function_arn = var.datadog_forwarder_function_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.bucket_subscription]
}


data "aws_iam_policy_document" "bucket_subscription" {
  for_each = var.subscriptions

  statement {
    sid = "DDForwarderAllowFetchBucketAndObjects"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetObject"
    ]

    resources = [
      each.value.bucket_arn,
      "${each.value.bucket_arn}/*"
    ]
  }
}


resource "aws_iam_policy" "bucket_subscription" {
  for_each = var.subscriptions

  name   = "${local.resource_name_prefix}-datadog-log-forwarder-policy-${each.key}"
  policy = data.aws_iam_policy_document.bucket_subscription[each.key].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "bucket_subscription" {
  for_each = var.subscriptions

  role       = var.datadog_forwarder_iam_role_name
  policy_arn = aws_iam_policy.bucket_subscription[each.key].arn
}

#############################
# Forwarder Stack Lambda
#############################
resource "aws_lambda_permission" "bucket_subscription" {
  for_each = var.subscriptions

  statement_id  = "AllowExecutionFromS3Bucket-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = var.datadog_forwarder_function_name
  principal     = "s3.amazonaws.com"
  source_arn    = each.value.bucket_arn
}

resource "aws_iam_role_policy_attachment" "datadog_forwarder_lambda_bucket" {
  for_each = var.subscriptions

  role       = var.datadog_forwarder_iam_role_name
  policy_arn = aws_iam_policy.bucket_subscription[each.key].arn
}
