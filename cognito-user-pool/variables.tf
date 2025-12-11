variable "project" {
  description = "The project name. Used for naming resources and domains."
  type        = string
}

variable "environment" {
  description = "The environment name. Used for naming resources and domains."
  type        = string
}

######################################################################
# User Pool
######################################################################
variable "user_pool_name" {
  description = "Name for the Cognito user pool. When this input is not supplied, the value defaults to `\"$${var.project}-$${var.environment}\"`."
  type        = string
  default     = ""
}

variable "default_user_pool_schema" {
  description = "Whether to use the default Cognito user pool schema, or the schema defined in `var.user_pool_schema`."
  type        = bool
  default     = false
}

variable "user_pool_schema" {
  description = "Schema attributes of the user pool. Custom attributes can be defined here as well. This variable is a map, to prevent terraform from trying to recreate all values when the list changes."

  type = map(object({
    attribute_data_type      = string
    name                     = string
    mutable                  = optional(bool)
    required                 = optional(bool)
    developer_only_attribute = optional(bool)
    number_attribute_constraints = optional(object({
      max_value = number
      min_value = number
    }))
    string_attribute_constraints = optional(object({
      max_length = number
      min_length = number
    }))
  }))

  validation {
    condition = alltrue(
      [
        for entry in values(var.user_pool_schema) :
        (entry.attribute_data_type == "String" && entry.string_attribute_constraints != null)
        || (entry.attribute_data_type == "Number" && entry.number_attribute_constraints != null)
      ]
    )

    error_message = "Data type constraints are needed for 'String' and 'Number' data types."
  }

  default = {
    email = {
      mutable             = true
      attribute_data_type = "String"
      name                = "email"
      required            = true

      string_attribute_constraints = {
        max_length = 256
        min_length = 5
      }
    },
    username = {
      mutable             = true
      attribute_data_type = "String"
      name                = "name"
      required            = true

      string_attribute_constraints = {
        max_length = 50
        min_length = 5
      }
    },
  }
}

variable "user_pool_alias_attributes" {
  description = "The user pool attributes supported as alias. Conflicts with `var.user_pool_username_attributes`. Options: phone_number, email, or preferred_username."
  type        = list(string)
  default     = ["email"]
}

variable "user_pool_username_attributes" {
  description = "The user pool attributes used for identifying users when a user signs up. Conflicts with `var.alias_attributes`."
  type        = list(string)
  default     = []
}

variable "user_pool_auto_verified_attributes" {
  description = "The user pool attributes that are auto verified."
  type        = list(string)
  default     = ["email"]
}

variable "user_pool_password_min_length" {
  description = "Minimum password length."
  type        = number
  default     = 60
}

variable "user_pool_password_req_lowercase" {
  description = "Passwords require lowercase characters."
  type        = bool
  default     = true
}

variable "user_pool_password_req_uppercase" {
  description = "Passwords require uppercase characters."
  type        = bool
  default     = true
}

variable "user_pool_password_req_numbers" {
  description = "Passwords require number characters."
  type        = bool
  default     = true
}

variable "user_pool_password_req_symbols" {
  description = "Passwords require symbol characters."
  type        = bool
  default     = true
}

variable "user_pool_temporary_password_validity_days" {
  description = "Days until a temporary password becomes invalid."
  type        = number
  default     = 7
}

variable "user_pool_account_recovery_mechanisms" {
  description = "Options for account recovery, in order of priority (first has more priority)"
  type        = list(string)
  default     = ["admin_only"]
}

variable "remember_device" {
  description = "Should the user pool store information about user devices. Options: always, user-opt-in, never"
  type        = string
  default     = "always"

  validation {
    condition     = contains(["always", "user-opt-in", "never"], var.remember_device)
    error_message = "Options for remebering device are always, user-opt-in, never"
  }
}

variable "challenge_required_on_new_device" {
  description = "Whether a challenge is required on a new device. Only applicable to a new device."
  type        = bool
  default     = true
}

variable "username_case_sensitive" {
  description = "Whether to make the username case sensitive"
  type        = bool
  default     = null
}

variable "verification_message_template" {
  description = "Configure a message to send to users when they need to verify their account."
  type = object({
    default_email_option  = optional(string)
    email_message         = optional(string)
    email_message_by_link = optional(string)
    email_subject         = optional(string)
    email_subject_by_link = optional(string)
    sms_message           = optional(string)
  })
  default = null
}

######################################################################
# User Pool Groups
######################################################################
variable "user_pool_groups" {
  description = "Groups defined in the user pool."
  type        = map(string)
  default     = {}
}

######################################################################
# User Pool Clients
######################################################################
variable "user_pool_clients" {
  description = "A list of objects describing the clients"

  type = map(object({
    name                            = string
    generate_secret                 = bool
    allow_oauth_flows               = bool
    callback_urls                   = list(string)
    callback_domains                = list(string)
    logout_urls                     = list(string)
    allowed_oauth_flows             = list(string)
    allowed_oauth_scopes            = list(string)
    explicit_auth_flows             = list(string)
    identity_providers              = list(string)
    write_attributes                = list(string)
    ignore_changes_to_callback_urls = optional(bool)
    enable_token_revocation         = optional(bool)
    prevent_user_existence_errors   = optional(string)
    auth_session_validity           = optional(number)
    token_validity_units = optional(object({
      access_token  = string
      id_token      = string
      refresh_token = string
    }))
  }))


  default = {
    client1 = {
      name                 = "default-client"
      generate_secret      = true
      allow_oauth_flows    = true
      callback_urls        = []
      callback_domains     = []
      logout_urls          = []
      allowed_oauth_flows  = ["code"]
      allowed_oauth_scopes = ["openid", "email"]
      explicit_auth_flows  = ["ADMIN_NO_SRP_AUTH"]
      identity_providers   = ["COGNITO"]
      write_attributes     = ["name", "email"]
    }
  }
}

######################################################################
# User Pool Domain
######################################################################
variable "configure_custom_domain" {
  description = "Whether to configure a custom domain name, or use the default generated by the module."
  type        = bool
  default     = false
}

variable "user_pool_default_domain_name" {
  description = "The prefix for the AWS generated domain name for the user pool."
  type        = string
  default     = ""
}

variable "user_pool_custom_domain_name" {
  description = "The full (custom) domain name for the user pool."
  type        = string
  default     = ""
}

variable "user_pool_custom_domain_certificate_arn" {
  description = "The ARN of the certificate for the custom domain."
  type        = string
  default     = ""
}

variable "user_pool_custom_domain_route53_zone_id" {
  description = "The id of the Route53 zone for the custom domain."
  type        = string
  default     = ""
}

variable "cloudfront_distribution_dnz_zone_id" {
  description = "The id of the Route53 zone used by AWS for CloudFront. This is typically constant, unless things change on AWS' side."
  type        = string
  default     = "Z2FDTNDATAQYW2"
}

######################################################################
# User Pool Identity Provider
######################################################################
variable "user_pool_identity_provider_name" {
  description = "The name for an identity provider. If set this will trigger the creation of the idp."
  type        = string
  default     = ""
}

variable "user_pool_identity_provider_type" {
  description = "The type of the idp."
  type        = string
  default     = ""
}

variable "user_pool_identity_provider_details" {
  description = "The configuration for the idp. Should include 'MetadataFile', 'SSORedirectBindingURI', and all other required parameters."
  type        = map(string)
  default     = {}
}

variable "user_pool_identity_provider_attribute_mapping" {
  description = "A mapping of idp attributes to user pool attributes."
  type        = map(string)
  default     = {}
}
