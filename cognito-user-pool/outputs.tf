output "user_pool_arn" {
  value = aws_cognito_user_pool.default.arn
}

output "user_pool_id" {
  value = aws_cognito_user_pool.default.id
}

output "user_pool_domain_name" {
  value = var.configure_custom_domain ? var.configure_custom_domain : local.default_domain
}

output "user_pool_endpoint" {
  value = aws_cognito_user_pool.default.endpoint
}

output "user_pool_clients" {
  value = merge(
    { for k, v in aws_cognito_user_pool_client.strict : v.name => v.id },
    { for k, v in aws_cognito_user_pool_client.ignore_changes_to_callback_urls : v.name => v.id },
  )
}

output "user_pool_client_secrets" {
  value = merge(
    { for k, v in aws_cognito_user_pool_client.strict : v.name => v.client_secret },
    { for k, v in aws_cognito_user_pool_client.ignore_changes_to_callback_urls : v.name => v.client_secret },
  )
  sensitive = true
}
