locals {
  user_pool_name = var.user_pool_name != "" ? var.user_pool_name : format("%s-%s", var.project, var.environment)
}

resource "aws_cognito_user_pool" "default" {
  name                     = local.user_pool_name
  alias_attributes         = length(var.user_pool_alias_attributes) > 0 ? var.user_pool_alias_attributes : null
  username_attributes      = length(var.user_pool_username_attributes) > 0 ? var.user_pool_username_attributes : null
  auto_verified_attributes = var.user_pool_auto_verified_attributes

  dynamic "username_configuration" {
    for_each = var.username_case_sensitive != null ? [var.username_case_sensitive] : []
    content {
      case_sensitive = username_configuration.value
    }
  }

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

  dynamic "schema" {
    for_each = var.default_user_pool_schema ? {} : var.user_pool_schema

    content {
      attribute_data_type      = schema.value["attribute_data_type"]
      name                     = schema.value["name"]
      mutable                  = try(schema.value["mutable"], null)
      required                 = try(schema.value["required"], null)
      developer_only_attribute = try(schema.value["developer_only_attribute"], null)

      dynamic "number_attribute_constraints" {
        # Using ["number_attribute_constraints"] as a non null value because if we use
        # schema.value["number_attribute_constraints"], even after the null check, there will be an error saying
        # Error: Invalid dynamic for_each value:
        #    schema.value["string_attribute_constraints"] is null
        # Cannot use a null value in for_each.
        for_each = schema.value["number_attribute_constraints"] != null ? ["number_attribute_constraints"] : []

        content {
          max_value = schema.value["number_attribute_constraints"]["max_value"]
          min_value = schema.value["number_attribute_constraints"]["min_value"]
        }
      }

      dynamic "string_attribute_constraints" {
        # Using ["string_attribute_constraints"] as a non null value because if we use
        # schema.value["string_attribute_constraints"], even after the null check, there will be an error saying
        # Error: Invalid dynamic for_each value:
        #    schema.value["string_attribute_constraints"] is null
        # Cannot use a null value in for_each.
        for_each = schema.value["string_attribute_constraints"] != null ? ["string_attribute_constraints"] : []

        content {
          max_length = schema.value["string_attribute_constraints"]["max_length"]
          min_length = schema.value["string_attribute_constraints"]["min_length"]
        }
      }
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

  dynamic "device_configuration" {
    for_each = var.remember_device == "never" ? [] : [var.remember_device]

    content {
      device_only_remembered_on_user_prompt = var.remember_device == "always" ? false : true
      challenge_required_on_new_device      = var.challenge_required_on_new_device
    }
  }

  dynamic "verification_message_template" {
    for_each = var.verification_message_template != null ? [var.verification_message_template] : []
    content {
      default_email_option  = verification_message_template.value["default_email_option"]
      email_message         = verification_message_template.value["email_message"]
      email_message_by_link = verification_message_template.value["email_message_by_link"]
      email_subject         = verification_message_template.value["email_subject"]
      email_subject_by_link = verification_message_template.value["email_subject_by_link"]
      sms_message           = verification_message_template.value["sms_message"]
    }
  }
}
