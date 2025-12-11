variable "name_prefix" {
  description = "Name prefix for all resources that will take them"
  type        = string
  default     = ""
}

variable "subscription_name" {
  description = "The name of the subscription."
  type        = string
  default     = null
}

variable "datadog_rds_function_arn" {
  description = "The ARN of the DD forwarder stack lambda"
  type        = string
}

variable "datadog_rds_function_name" {
  description = "The name of the DD forwarder stack lambda"
  type        = string
}

variable "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group for RDS OS metrics"
  type        = string
  default     = "RDSOSMetrics"
}

variable "cloudwatch_subscription_filter_pattern" {
  description = "A valid CloudWatch Logs filter pattern for subscribing to a filtered stream of log events."
  type        = string
  default     = ""
}

variable "cloudwatch_subscription_distribution" {
  description = "The method used to distribute log data to the destination. By default log data is grouped by log stream, but the grouping can be set to random for a more even distribution. This property is only applicable when the destination is an Amazon Kinesis stream. Valid values are \"Random\" and \"ByLogStream\"."
  type        = string
  default     = "Random"
}
