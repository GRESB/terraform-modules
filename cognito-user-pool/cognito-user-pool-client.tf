locals {
  aws_region     = data.aws_region.current.region
  default_domain = "${join("", aws_cognito_user_pool_domain.default_domain[*].domain)}.auth.${local.aws_region}.amazoncognito.com"

  token_validity_units = {
    default = {
      access_token  = "hours"
      id_token      = "hours"
      refresh_token = "days"
    }
  }
}

resource "aws_cognito_user_pool_client" "strict" {
  for_each = { for name, config in var.user_pool_clients : name => config if config.ignore_changes_to_callback_urls != true }

  name            = each.value["name"]
  user_pool_id    = aws_cognito_user_pool.default.id
  generate_secret = each.value["generate_secret"]

  enable_token_revocation       = each.value["enable_token_revocation"] != null ? each.value["enable_token_revocation"] : true
  prevent_user_existence_errors = each.value["prevent_user_existence_errors"] != null ? each.value["prevent_user_existence_errors"] : "LEGACY"
  auth_session_validity         = each.value["auth_session_validity"] != null ? each.value["auth_session_validity"] : 3

  callback_urls = toset(concat(each.value["callback_urls"], flatten([for domain in each.value["callback_domains"] : [
    "https://${domain}",
    "https://${domain}/oauth2/idpresponse",
    "https://${domain}/saml2/idpresponse",
    ]]), var.configure_custom_domain ? [
    "https://${var.configure_custom_domain}",
    "https://${var.configure_custom_domain}/oauth2/idpresponse",
    "https://${var.configure_custom_domain}/saml2/idpresponse",
    ] : [
    "https://${local.default_domain}",
    "https://${local.default_domain}/oauth2/idpresponse",
    "https://${local.default_domain}/saml2/idpresponse",
  ]))

  logout_urls = each.value["logout_urls"]

  allowed_oauth_flows  = each.value["allowed_oauth_flows"]
  allowed_oauth_scopes = each.value["allowed_oauth_scopes"]

  explicit_auth_flows = each.value["explicit_auth_flows"]

  allowed_oauth_flows_user_pool_client = each.value["allow_oauth_flows"]

  supported_identity_providers = concat(each.value["identity_providers"], local.create_identity_provider ? aws_cognito_identity_provider.user_pool_idp[*].provider_name : [])

  write_attributes = each.value["write_attributes"]

  dynamic "token_validity_units" {
    # Always set a default value to prevent provisioning issues
    for_each = each.value["token_validity_units"] != null ? { user = each.value["token_validity_units"] } : local.token_validity_units

    content {
      access_token  = token_validity_units.value["access_token"]
      id_token      = token_validity_units.value["id_token"]
      refresh_token = token_validity_units.value["refresh_token"]
    }
  }

  depends_on = [aws_cognito_identity_provider.user_pool_idp]
}

resource "aws_cognito_user_pool_client" "ignore_changes_to_callback_urls" {
  for_each = { for name, config in var.user_pool_clients : name => config if config.ignore_changes_to_callback_urls == true }

  name            = each.value["name"]
  user_pool_id    = aws_cognito_user_pool.default.id
  generate_secret = each.value["generate_secret"]

  enable_token_revocation       = each.value["enable_token_revocation"] != null ? each.value["enable_token_revocation"] : true
  prevent_user_existence_errors = each.value["prevent_user_existence_errors"] != null ? each.value["prevent_user_existence_errors"] : false
  auth_session_validity         = each.value["auth_session_validity"] != null ? each.value["auth_session_validity"] : 3

  callback_urls = toset(concat(each.value["callback_urls"], flatten([for domain in each.value["callback_domains"] : [
    "https://${domain}",
    "https://${domain}/oauth2/idpresponse",
    "https://${domain}/saml2/idpresponse",
    ]]), var.configure_custom_domain ? [
    "https://${var.configure_custom_domain}",
    "https://${var.configure_custom_domain}/oauth2/idpresponse",
    "https://${var.configure_custom_domain}/saml2/idpresponse",
    ] : [
    "https://${local.default_domain}",
    "https://${local.default_domain}/oauth2/idpresponse",
    "https://${local.default_domain}/saml2/idpresponse",
  ]))

  logout_urls = each.value["logout_urls"]

  allowed_oauth_flows  = each.value["allowed_oauth_flows"]
  allowed_oauth_scopes = each.value["allowed_oauth_scopes"]

  explicit_auth_flows = each.value["explicit_auth_flows"]

  allowed_oauth_flows_user_pool_client = each.value["allow_oauth_flows"]

  supported_identity_providers = concat(each.value["identity_providers"], local.create_identity_provider ? aws_cognito_identity_provider.user_pool_idp[*].provider_name : [])

  write_attributes = each.value["write_attributes"]

  dynamic "token_validity_units" {
    # Always set a default value to prevent provisioning issues
    for_each = each.value["token_validity_units"] != null ? { user = each.value["token_validity_units"] } : local.token_validity_units

    content {
      access_token  = token_validity_units.value["access_token"]
      id_token      = token_validity_units.value["id_token"]
      refresh_token = token_validity_units.value["refresh_token"]
    }
  }



  depends_on = [aws_cognito_identity_provider.user_pool_idp]

  lifecycle {
    ignore_changes = [
      callback_urls,
    ]
  }
}


data "aws_region" "current" {}
