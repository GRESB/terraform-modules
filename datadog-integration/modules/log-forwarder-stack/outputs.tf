output "log_forwarder_stack_id" {
  value = aws_cloudformation_stack.forwarder.id
}

output "log_forwarder_stack_outputs" {
  value = aws_cloudformation_stack.forwarder.outputs
}

output "log_forwarder_iam_role_arn" {
  value = local.forwarder_iam_role_arn
}

output "log_forwarder_iam_role_name" {
  value = local.forwarder_iam_role_name
}

output "log_forwarder_function_arn" {
  value = local.function_arn
}

output "log_forwarder_function_name" {
  value = local.function_name
}

output "log_forwarder_bucket_subscription_kms_keys" {
  value = local.bucket_subscription_kms_keys
}
