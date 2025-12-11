terraform {
  required_version = "~> 1.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    datadog = {
      source  = "datadog/datadog"
      version = "~> 3.16"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "sb-ben-dev-bootstrap"
}

variable "datadog_api_key" { type = string }
variable "datadog_app_key" { type = string }

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = "https://api.datadoghq.eu/"
}

variable "name_prefix" {
  type    = string
  default = "this-is-a-test"
}

module "datadog_integration" {
  source = "../../"

  name_prefix     = var.name_prefix
  datadog_api_key = var.datadog_api_key

  filter_tags = {
    foo = "bar"
  }

  tags = {
    dd-integration-test = "dd-integration-test"
  }

  account_specific_namespace_rules = {
    "api_gateway"            = "true"
    "application_elb"        = "true"
    "appstream"              = "true"
    "appsync"                = "true"
    "athena"                 = "true"
    "auto_scaling"           = "true"
    "billing"                = "true"
    "budgeting"              = "true"
    "cloudfront"             = "true"
    "cloudsearch"            = "true"
    "cloudwatch_events"      = "true"
    "cloudwatch_logs"        = "true"
    "codebuild"              = "true"
    "cognito"                = "false"
    "collect_custom_metrics" = "false"
    "connect"                = "false"
    "crawl_alarms"           = "false"
    "directconnect"          = "false"
  }

  enable_datadog_forwarder_stack = true
  enable_datadog_rds_stack       = true
}


module "log_forwarder_bucket_subscriptions" {
  source = "../../modules/log-forwarder-bucket-subscription"

  name_prefix = var.name_prefix
  tags = {
    some = "tag"
  }

  datadog_forwarder_function_arn  = module.datadog_integration.datadog_log_forwarder_function_arn
  datadog_forwarder_function_name = module.datadog_integration.datadog_log_forwarder_function_name
  datadog_forwarder_iam_role_name = module.datadog_integration.datadog_log_forwarder_iam_role_name

  subscriptions = {
    bucket1 = {
      bucket_arn   = module.bucket1.s3_bucket_arn
      kms_key_arn  = module.bucket1_cmk.key_arn
      is_encrypted = true
    }

    bucket2 = {
      bucket_arn   = module.bucket2.s3_bucket_arn
      kms_key_arn  = null
      is_encrypted = false
    }
  }
}

module "log_forwarder_cloudwatch_event_subscriptions" {
  source = "../../modules/log-forwarder-cloudwatch-event-subscription"

  enabled     = true
  name_prefix = var.name_prefix
  tags = {
    some = "tag"
  }

  datadog_forwarder_function_arn  = module.datadog_integration.datadog_log_forwarder_function_arn
  datadog_forwarder_function_name = module.datadog_integration.datadog_log_forwarder_function_name

  subscriptions = {
    guardduty-findings = {
      source      = "aws.guardduty"
      detail_type = "GuardDuty Finding"
    }
    config-findings = {
      source      = "aws.config"
      detail_type = "Config Finding"
    }
  }
}

module "rds_enhanced_cloudwatch_log_subscription" {
  source = "../../modules/rds-enhanced-cloudwatch-log-subscription"

  name_prefix = var.name_prefix

  subscription_name = "rds-enhanced"

  datadog_rds_function_arn  = module.datadog_integration.datadog_rds_enhanced_function_arn
  datadog_rds_function_name = module.datadog_integration.datadog_rds_enhanced_function_name

  cloudwatch_log_group_name              = aws_cloudwatch_log_group.test.name
  cloudwatch_subscription_filter_pattern = "" # all
  cloudwatch_subscription_distribution   = "Random"
}

###########################
# Buckets
###########################
variable "bucket1_name" {
  type    = string
  default = "datadog-integration-complete-example"
}

module "bucket1" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3"

  bucket        = var.bucket1_name
  acl           = "log-delivery-write"
  force_destroy = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = module.bucket1_cmk.key_arn
      }
    }
  }
}

module "bucket1_cmk" {
  source = "git::https://gitlab.com/open-source-devex/terraform-modules/aws/kms-key.git?ref=v2.1.0"

  key_name        = var.bucket1_name
  key_description = "CMK for S3 bucket ${var.bucket1_name}"
}

variable "bucket2_name" {
  type    = string
  default = "datadog-integration-complete-example-without-cmk"
}

module "bucket2" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3"

  bucket        = var.bucket2_name
  acl           = "log-delivery-write"
  force_destroy = true
}

resource "random_pet" "name" {}

###########################
# Log Groups
###########################
resource "aws_cloudwatch_log_group" "test" {}
