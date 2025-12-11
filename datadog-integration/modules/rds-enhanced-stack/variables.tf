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

variable "configure_rds_subscription" {
  description = "Whether to enable the CloudWatch log subscription and ship logs to DD"
  type        = bool
  default     = true
}

variable "datadog_site" {
  description = "The DD site to set as a parameter to the cloudFormation stack"
  type        = string
  default     = "datadoghq.eu"
}

variable "datadog_api_key_secret_arn" {
  description = "The ARN of a AWS SecretsManager secret containing the DD API key to be used in the forwarding stack"
  type        = string
}

variable "custom_rds_stack_python_version" {
  description = "Python version to use for Lambda Function"
  type        = string
  default     = "python3.7"
}

variable "custom_rds_stack_template" {
  description = "A stack template to be used instead of the default DD stack template"
  type        = string
  default     = null
}

variable "custom_rds_stack_kms_key_policy" {
  description = "A addition KMS Key policy"
  type = list(object({
    principals = list(object({
      type = string, identifiers = list(string)
    }))
    effect    = string
    actions   = list(string)
    resources = list(string)
    condition = list(object({
      test     = string
      variable = string
      values   = list(string)
    }))
  }))
  default = []
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

variable "use_vpc" {
  description = "Whether to use VPC or not."
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  description = "The VPC security group ids to use. Comma separated list."
  type        = string
  default     = ""
}

variable "vpc_subnet_ids" {
  description = "The VPC subnets to use. Comma separated list."
  type        = string
  default     = ""
}

variable "code_s3_bucket" {
  description = "The bucket where the lambda function package can be found"
  type        = string
}

variable "code_s3_object" {
  description = "The bucket object with the lambda function. Source https://github.com/DataDog/datadog-serverless-functions/tree/master/aws/rds_enhanced_monitoring"
  type        = string
}

variable "datadog_integration_role_arn" {
  description = "The datadog aws integration role arn."
  type        = string
}
