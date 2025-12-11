output "rds_enhanced_stack_id" {
  value = aws_cloudformation_stack.rds.id
}

output "rds_enhanced_stack_outputs" {
  value = aws_cloudformation_stack.rds.outputs
}

output "rds_enhanced_iam_role_arn" {
  value = local.role_arn
}

output "rds_enhanced_iam_role_name" {
  value = local.role_name
}

output "rds_enhanced_function_arn" {
  value = local.function_arn
}

output "rds_enhanced_function_name" {
  value = local.function_name
}
