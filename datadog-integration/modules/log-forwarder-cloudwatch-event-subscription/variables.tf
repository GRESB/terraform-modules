variable "enabled" {
  description = "Whether to create the resources in this module"
  type        = bool
  default     = true
}

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

variable "datadog_forwarder_function_arn" {
  description = "The ARN of the DD forwarder stack lambda"
  type        = string
}

variable "datadog_forwarder_function_name" {
  description = "The name of the DD forwarder stack lambda"
  type        = string
}
