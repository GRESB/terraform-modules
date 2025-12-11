##########################################################################################################
# Implementation of CloudWatch log destination triggering lambda function
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html#LambdaFunctionExample
##########################################################################################################
resource "aws_cloudwatch_log_subscription_filter" "log_subscription" {
  count = var.subscription_name != null ? 1 : 0

  name            = "${local.resource_name_prefix}-${var.subscription_name}"
  log_group_name  = var.cloudwatch_log_group_name
  filter_pattern  = var.cloudwatch_subscription_filter_pattern
  destination_arn = var.datadog_rds_function_arn
  distribution    = var.cloudwatch_subscription_distribution

  depends_on = [aws_lambda_permission.log_subscription]
}

#############################
# Forwarder Stack Lambda
#############################
resource "aws_lambda_permission" "log_subscription" {
  count = var.subscription_name != null ? 1 : 0

  statement_id  = "AllowExecutionFromCloudWatch-${var.subscription_name}"
  action        = "lambda:InvokeFunction"
  function_name = var.datadog_rds_function_name
  principal     = "logs.amazonaws.com"
  source_arn    = join("", data.aws_cloudwatch_log_group.rds_os_metrics[*].arn)
}

data "aws_cloudwatch_log_group" "rds_os_metrics" {
  count = var.subscription_name != null ? 1 : 0

  name = var.cloudwatch_log_group_name
}
