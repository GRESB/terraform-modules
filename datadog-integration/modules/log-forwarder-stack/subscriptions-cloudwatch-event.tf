module "cloudwatch_event_subscriptions" {
  source = "../log-forwarder-cloudwatch-event-subscription"

  name_prefix = var.name_prefix
  tags        = var.tags

  datadog_forwarder_function_arn  = local.function_arn
  datadog_forwarder_function_name = local.function_name

  subscriptions = var.forwarder_cloudwatch_event_subscriptions
}
