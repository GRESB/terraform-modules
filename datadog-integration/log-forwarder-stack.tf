module "log_forwarder_stack" {
  source = "./modules/log-forwarder-stack"

  for_each = toset(var.enable_datadog_forwarder_stack ? ["enabled"] : [])

  name_prefix = var.name_prefix
  tags        = var.tags

  datadog_site               = var.datadog_site
  datadog_api_key_secret_arn = local.datadog_api_key_secret_arn

  forwarder_use_vpc                = var.datadog_forwarder_use_vpc
  forwarder_vpc_subnet_ids         = var.datadog_forwarder_vpc_subnet_ids
  forwarder_vpc_security_group_ids = var.datadog_forwarder_vpc_security_group_ids

  forwarder_include_at_match = var.datadog_forwarder_include_at_match

  forwarder_bucket_subscriptions               = var.datadog_forwarder_bucket_subscriptions
  forwarder_cloudwatch_event_subscriptions     = var.datadog_forwarder_cloudwatch_event_subscriptions
  forwarder_cloudwatch_log_group_subscriptions = var.datadog_forwarder_cloudwatch_log_group_subscriptions
}
