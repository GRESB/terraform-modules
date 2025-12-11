module "rds_enhanced_stack" {
  source = "./modules/rds-enhanced-stack"

  for_each = toset(var.enable_datadog_rds_stack ? ["enabled"] : [])

  name_prefix = var.name_prefix
  tags        = var.tags

  datadog_api_key_secret_arn   = local.datadog_api_key_secret_arn
  datadog_site                 = var.datadog_site
  datadog_integration_role_arn = aws_iam_role.datadog_integration.arn

  use_vpc                = var.datadog_rds_use_vpc
  vpc_subnet_ids         = var.datadog_rds_vpc_subnet_ids
  vpc_security_group_ids = var.datadog_rds_vpc_security_group_ids

  custom_rds_stack_template       = var.custom_datadog_rds_stack_template
  custom_rds_stack_python_version = var.custom_rds_stack_python_version
  custom_rds_stack_kms_key_policy = var.custom_rds_stack_kms_key_policy

  configure_rds_subscription             = var.datadog_rds_configure_subscription
  cloudwatch_log_group_name              = var.datadog_rds_cloudwatch_log_group_name
  cloudwatch_subscription_filter_pattern = var.datadog_rds_cloudwatch_subscription_filter_pattern
  cloudwatch_subscription_distribution   = var.datadog_rds_cloudwatch_subscription_distribution

  code_s3_bucket = var.datadog_code_s3_bucket
  code_s3_object = var.datadog_rds_code_s3_object
}
