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

variable "subscriptions" {
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

variable "datadog_forwarder_function_arn" {
  description = "The ARN of the DD forwarder stack lambda"
  type        = string
}

variable "datadog_forwarder_function_name" {
  description = "The name of the DD forwarder stack lambda"
  type        = string
}

variable "datadog_forwarder_iam_role_name" {
  description = "The name of the IAM role for DataDog"
  type        = string
}
