#############################
# CloudWatch Event
#############################
resource "aws_cloudwatch_event_rule" "cloudwatch_subscription" {
  for_each = var.enabled ? var.subscriptions : {}

  name        = "${local.resource_name_prefix}-capture-${each.key}"
  description = "Capture ${each.key} events"

  event_pattern = <<PATTERN
{
  "source": [
    "${each.value.source}"
  ],
  "detail-type": [
    "${each.value.detail_type}"
  ]
}
PATTERN

  tags = var.tags
}

# Trigger the log forwarder to pick up the even
resource "aws_cloudwatch_event_target" "cloudwatch_subscription" {
  for_each = var.enabled ? var.subscriptions : {}

  rule      = aws_cloudwatch_event_rule.cloudwatch_subscription[each.key].name
  target_id = "${local.resource_name_prefix}-ddforwarder-${each.key}"
  arn       = var.datadog_forwarder_function_arn
}

#############################
# Forwarder Stack Lambda
#############################
resource "aws_lambda_permission" "allow_cloudwatch_to_call_datadog_forwarder" {
  for_each = var.enabled ? var.subscriptions : {}

  statement_id  = "AllowExecutionFromCloudWatch-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = var.datadog_forwarder_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cloudwatch_subscription[each.key].arn
}
