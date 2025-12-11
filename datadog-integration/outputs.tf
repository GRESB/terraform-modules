output "datadog_integration_role_arn" {
  value = aws_iam_role.datadog_integration.arn
}

output "datadog_integration_role_name" {
  value = aws_iam_role.datadog_integration.name
}

output "datadog_log_forwarder_stack_id" {
  value = try(module.log_forwarder_stack["enabled"].log_forwarder_stack_id, "")
}

output "datadog_log_forwarder_stack_outputs" {
  value = try(module.log_forwarder_stack["enabled"].log_forwarder_stack_outputs, {})
}

output "datadog_log_forwarder_iam_role_arn" {
  value = try(module.log_forwarder_stack["enabled"].log_forwarder_iam_role_arn, "")
}

output "datadog_log_forwarder_iam_role_name" {
  value = try(module.log_forwarder_stack["enabled"].log_forwarder_iam_role_name, "")
}

output "datadog_log_forwarder_function_arn" {
  value = try(module.log_forwarder_stack["enabled"].log_forwarder_function_arn, "")
}

output "datadog_log_forwarder_function_name" {
  value = try(module.log_forwarder_stack["enabled"].log_forwarder_function_name, "")
}

output "datadog_rds_enhanced_stack_id" {
  value = try(module.rds_enhanced_stack["enabled"].rds_enhanced_stack_id, "")
}

output "datadog_rds_enhanced_stack_outputs" {
  value = try(module.rds_enhanced_stack["enabled"].rds_enhanced_stack_outputs, "")
}

output "datadog_rds_enhanced_iam_role_arn" {
  value = try(module.rds_enhanced_stack["enabled"].rds_enhanced_iam_role_arn, "")
}

output "datadog_rds_enhanced_iam_role_name" {
  value = try(module.rds_enhanced_stack["enabled"].rds_enhanced_iam_role_name, "")
}

output "datadog_rds_enhanced_function_arn" {
  value = try(module.rds_enhanced_stack["enabled"].rds_enhanced_function_arn, "")
}

output "datadog_rds_enhanced_function_name" {
  value = try(module.rds_enhanced_stack["enabled"].rds_enhanced_function_name, "")
}

output "datadog_secret_name" {
  value = local.datadog_api_secret_name
}

output "datadog_api_key_secret_arn" {
  value = local.datadog_api_key_secret_arn
}
