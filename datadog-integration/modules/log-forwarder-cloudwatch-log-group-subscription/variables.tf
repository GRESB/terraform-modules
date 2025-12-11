variable "name_prefix" {
  description = "Name prefix for all resources that will take them"
  type        = string
  default     = ""
}

variable "datadog_forwarder_function_arn" {
  description = "The ARN of the DD forwarder stack lambda"
  type        = string
}

variable "datadog_forwarder_function_name" {
  description = "The name of the DD forwarder stack lambda"
  type        = string
}

variable "cloudwatch_log_groups" {
  description = "The CloudWatch log groups to be forwarded to DataDog."
  type        = map(object({ log_group_name : string, subscription_filter_pattern : string }))
  default = {
    #    subscription_name = {
    #      log_group_name = "the-log-group"
    #      subscription_filter_pattern = "" # empty to send all the logs
    #    }
  }
}

variable "cloudwatch_subscription_distribution" {
  description = "The method used to distribute log data to the destination. By default log data is grouped by log stream, but the grouping can be set to random for a more even distribution. This property is only applicable when the destination is an Amazon Kinesis stream. Valid values are \"Random\" and \"ByLogStream\"."
  type        = string
  default     = "Random"
}
