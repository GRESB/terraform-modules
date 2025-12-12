locals {
  user_pool_name = var.user_pool_name != "" ? var.user_pool_name : format("%s-%s", var.project, var.environment)
}

resource "aws_cognito_user_pool" "default" {
  name                     = local.user_pool_name
  alias_attributes         = var.user_pool_alias_attributes
  auto_verified_attributes = var.user_pool_auto_verified_attributes

  password_policy {
    minimum_length                   = var.user_pool_password_min_length
    require_lowercase                = var.user_pool_password_req_lowercase
    require_numbers                  = var.user_pool_password_req_numbers
    require_symbols                  = var.user_pool_password_req_symbols
    require_uppercase                = var.user_pool_password_req_uppercase
    temporary_password_validity_days = var.user_pool_temporary_password_validity_days
  }

  tags = {
    project     = var.project
    environment = var.environment
  }

  schema {
    mutable             = true
    attribute_data_type = "String"
    name                = "email"
    required            = true

    string_attribute_constraints {
      max_length = 256
      min_length = 5
    }
  }

  schema {
    mutable             = true
    attribute_data_type = "String"
    name                = "name"
    required            = true

    string_attribute_constraints {
      max_length = 50
      min_length = 5
    }
  }

  account_recovery_setting {
    dynamic "recovery_mechanism" {
      for_each = var.user_pool_account_recovery_mechanisms

      content {
        name     = recovery_mechanism.value
        priority = recovery_mechanism.key + 1
      }
    }
  }

  dynamic "schema" {
    for_each = var.user_pool_custom_attributes

    content {
      name                     = schema.value.name
      attribute_data_type      = schema.value.attribute_data_type
      developer_only_attribute = schema.value.developer_only_attribute
      mutable                  = schema.value.mutable

      dynamic "number_attribute_constraints" {
        for_each = schema.value.number_attribute_constraints != null ? ["number_attribute_constraints"] : []

        content {
          min_value = schema.value.number_attribute_constraints.min_value
          max_value = schema.value.number_attribute_constraints.max_value
        }
      }

      dynamic "string_attribute_constraints" {
        for_each = schema.value.string_attribute_constraints != null ? ["string_attribute_constraints"] : []

        content {
          min_length = schema.value.string_attribute_constraints.min_length
          max_length = schema.value.string_attribute_constraints.max_length
        }
      }
    }
  }

  device_configuration {
    device_only_remembered_on_user_prompt = var.remember_device
  }
}
