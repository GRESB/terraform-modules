locals {
  create_identity_provider = var.user_pool_identity_provider_name != ""
}

resource "aws_cognito_identity_provider" "user_pool_idp" {
  count = local.create_identity_provider ? 1 : 0

  user_pool_id = aws_cognito_user_pool.default.id

  provider_name = var.user_pool_identity_provider_name
  provider_type = var.user_pool_identity_provider_type

  provider_details = var.user_pool_identity_provider_details

  attribute_mapping = var.user_pool_identity_provider_attribute_mapping

  # This is not supported by AWS hence keeps fluctuating
  lifecycle {
    ignore_changes = [provider_details["ActiveEncryptionCertificate"]]
  }
}
