##########################################################################################################
# Implementation of CloudWatch log destination triggering lambda function
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html#LambdaFunctionExample
##########################################################################################################
resource "aws_cloudwatch_log_subscription_filter" "log_subscription" {
  for_each = var.cloudwatch_log_groups

  name            = "${local.resource_name_prefix}-${each.key}"
  log_group_name  = data.aws_cloudwatch_log_group.groups[each.key].name
  filter_pattern  = each.value.subscription_filter_pattern
  destination_arn = var.datadog_forwarder_function_arn
  distribution    = var.cloudwatch_subscription_distribution

  depends_on = [aws_lambda_permission.log_subscription]
}

#############################
# Forwarder Stack Lambda
#############################
resource "aws_lambda_permission" "log_subscription" {
  for_each = var.cloudwatch_log_groups

  statement_id  = "AllowExecutionFromCloudWatch-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = var.datadog_forwarder_function_name
  principal     = "logs.amazonaws.com"
  source_arn    = data.aws_cloudwatch_log_group.groups[each.key].arn
}

data "aws_cloudwatch_log_group" "groups" {
  for_each = var.cloudwatch_log_groups

  name = each.value.log_group_name
}
