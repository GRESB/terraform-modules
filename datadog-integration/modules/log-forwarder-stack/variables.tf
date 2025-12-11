variable "name_prefix" {
  description = "Name prefix for all resources that will take them"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags appended to all resources that will take them"
  type        = map(string)
  default     = {}
}

variable "datadog_site" {
  description = "The DD site to set as a parameter to the cloudFormation stack. Se valid options here https://docs.datadoghq.com/getting_started/site/"
  type        = string
  default     = "datadoghq.eu"
}

variable "forwarder_include_at_match" {
  description = "Regex pattern on which to filter. if set to empty string, no filtering is applied"
  type        = string
  default     = ""
}

variable "forwarder_use_vpc" {
  description = "Whether to use VPC or not."
  type        = bool
  default     = false
}

variable "forwarder_vpc_security_group_ids" {
  description = "The VPC security group ids to use. Comma separated list."
  type        = string
  default     = ""
}

variable "forwarder_vpc_subnet_ids" {
  description = "The VPC subnets to use. Comma separated list."
  type        = string
  default     = ""
}

variable "datadog_api_key_secret_arn" {
  description = "The ARN of a AWS SecretsManager secret containing the DD API key to be used in the forwarding stack"
  type        = string
}

variable "forwarder_bucket_subscriptions" {
  description = "Map of bucket names to a pairs of bucket ARN and KMS key ARN. This map is used to configure forwarding logs from the respective bucekts to DD."

  type = map(object({
    bucket_arn   = string
    is_encrypted = bool
    kms_key_arn  = string
  }))

  default = {
    # bucket-name = {
    #   bucket_arn  = "arn"
    #   kms_key_arn = "arn"
    # }
  }
}

variable "forwarder_cloudwatch_event_subscriptions" {
  description = "Map of CloudWatch event subscriptions"

  type = map(object({
    source      = string
    detail_type = string
  }))

  default = {
    # guardduty-finding = {
    #   source = "aws.guardduty"
    #   detail_type = "GuardDuty Finding"
    #
  }
}

variable "forwarder_cloudwatch_log_group_subscriptions" {
  description = "Map of CloudWatch log group subscriptions"

  type = map(object({
    log_group_name              = string
    subscription_filter_pattern = string
  }))

  default = {
    #    subscription_name = {
    #      log_group_name = "the-log-group"
    #      subscription_filter_pattern = "" # empty to send all the logs
    #    }
  }
}
