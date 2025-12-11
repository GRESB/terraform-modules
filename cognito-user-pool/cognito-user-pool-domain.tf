locals {
  user_pool_default_domain_name = var.user_pool_default_domain_name != "" ? var.user_pool_default_domain_name : format("%s-%s-auth", var.project, var.environment)
}

resource "aws_cognito_user_pool_domain" "default_domain" {
  count = var.configure_custom_domain ? 0 : 1

  domain       = local.user_pool_default_domain_name
  user_pool_id = aws_cognito_user_pool.default.id
}

resource "aws_cognito_user_pool_domain" "custom_domain" {
  count = var.configure_custom_domain ? 1 : 0

  domain          = var.user_pool_custom_domain_name
  certificate_arn = var.user_pool_custom_domain_certificate_arn
  user_pool_id    = aws_cognito_user_pool.default.id

  lifecycle {
    create_before_destroy = true
  }
}
