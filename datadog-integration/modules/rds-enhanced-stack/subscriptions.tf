module "subscription" {
  source = "../rds-enhanced-cloudwatch-log-subscription"

  for_each = toset(var.configure_rds_subscription ? ["enabled"] : [])

  name_prefix = var.name_prefix

  datadog_rds_function_arn  = local.function_arn
  datadog_rds_function_name = local.function_name

  subscription_name = "rds-enhanced"

  cloudwatch_log_group_name              = var.cloudwatch_log_group_name
  cloudwatch_subscription_filter_pattern = var.cloudwatch_subscription_filter_pattern
  cloudwatch_subscription_distribution   = var.cloudwatch_subscription_distribution
}
