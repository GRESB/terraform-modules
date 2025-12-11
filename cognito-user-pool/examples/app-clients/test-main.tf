terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "user_pool" {
  source = "../../"

  project     = "test"
  environment = "app-clients-example"

  user_pool_name = "app-clients-example-user-pool"

  user_pool_alias_attributes         = ["email", "phone_number"]
  user_pool_auto_verified_attributes = ["email"]

  user_pool_schema = {
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
    foo = {
      name                = "foo"
      attribute_data_type = "String"
      string_attribute_constraints = {
        min_length = 1
        max_length = 256
      }
    },
    bar = {
      name                = "bar"
      attribute_data_type = "Number"
      number_attribute_constraints = {
        min_value = 1
        max_value = 100
      }
    }
  }

  user_pool_password_min_length    = 30
  user_pool_password_req_lowercase = false
  user_pool_password_req_uppercase = false
  user_pool_password_req_numbers   = false
  user_pool_password_req_symbols   = false

  user_pool_account_recovery_mechanisms = ["verified_email", "verified_phone_number"]

  remember_device                  = "user-opt-in"
  challenge_required_on_new_device = false

  user_pool_groups = {
    testgroup = "this is a test group"
  }

  user_pool_clients = {
    client1 = {
      name                 = "test-client-1"
      generate_secret      = true
      allow_oauth_flows    = true
      callback_urls        = ["https://google.com/foo/bar"]
      callback_domains     = ["microsoft.com"]
      logout_urls          = ["https://bing.com"]
      allowed_oauth_flows  = ["code"]
      allowed_oauth_scopes = ["openid", "email"]
      explicit_auth_flows  = ["ADMIN_NO_SRP_AUTH"]
      identity_providers   = ["COGNITO"]
      write_attributes     = []
    }
    client2 = {
      name                          = "test-client-2"
      generate_secret               = false
      allow_oauth_flows             = false
      callback_urls                 = ["https://google.comfoo/bar"]
      callback_domains              = ["microsoft.com"]
      logout_urls                   = ["https://bing.com"]
      allowed_oauth_flows           = []
      allowed_oauth_scopes          = []
      explicit_auth_flows           = []
      identity_providers            = ["COGNITO"]
      write_attributes              = []
      enable_token_revocation       = false
      prevent_user_existence_errors = "ENABLED"
      auth_session_validity         = 8
      token_validity_units = {
        access_token  = "days"
        id_token      = "days"
        refresh_token = "hours"
      }
    }
  }
}
