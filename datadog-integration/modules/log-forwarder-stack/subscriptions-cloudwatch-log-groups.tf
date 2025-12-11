module "cloudwatch_log_group_subscriptions" {
  source = "../log-forwarder-cloudwatch-log-group-subscription"

  name_prefix = var.name_prefix

  datadog_forwarder_function_arn  = local.function_arn
  datadog_forwarder_function_name = local.function_name

  cloudwatch_log_groups = var.forwarder_cloudwatch_log_group_subscriptions
}
