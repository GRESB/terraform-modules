locals {
  bucket_subscription_kms_keys = { for name, info in var.forwarder_bucket_subscriptions : name => info.kms_key_arn if info.is_encrypted }
}

module "bucket_subscriptions" {
  source = "../log-forwarder-bucket-subscription"

  name_prefix = var.name_prefix
  tags        = var.tags

  datadog_forwarder_function_arn  = local.function_arn
  datadog_forwarder_function_name = local.function_name
  datadog_forwarder_iam_role_name = local.forwarder_iam_role_name

  subscriptions = var.forwarder_bucket_subscriptions
}
