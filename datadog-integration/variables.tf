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

variable "enable_security_audit_iam" {
  description = "Whether to attach the SecurityAudit IAM policy to the DataDog integration role."
  type        = bool
  default     = false
}

variable "enable_datadog_forwarder_stack" {
  description = "Whether to enable the DD forwarder lambda stack"
  type        = bool
  default     = false
}

variable "enable_datadog_rds_stack" {
  description = "Whether to enable the DD RDS Enhanced lambda stack"
  type        = bool
  default     = false
}

variable "datadog_api_key" {
  description = "The API key used for the DataDog provider"
  type        = string
  default     = ""
}

variable "create_datadog_api_key_secret" {
  description = "Whether to create a AWS SecretsManager secret for DD API key, when set to false `datadog_api_key_secret_arn` must be set to a valid ARN"
  type        = bool
  default     = true
}

variable "datadog_api_key_secret_arn" {
  description = "The ARN of a pre-existing AWS SecretsManager secret containing the DD API key to be used in the forwarding stack. Conflicts with `create_forwarder_api_key_secret`."
  type        = string
  default     = ""
}

variable "datadog_site" {
  description = "The DD site to set as a parameter to the cloudFormation stack"
  type        = string
  default     = "datadoghq.eu"
}

variable "aws_account_tags" {
  description = "Tags to apply to all metrics in the account."
  type        = list(string)
  default     = []
}

variable "aws_account_id" {
  description = "The ID of the AWS account to integrate with DD"
  type        = string
  default     = null
}

variable "datadog_code_s3_bucket" {
  description = "The bucket where the lambda function packages can be found."
  type        = string
  default     = null
}

variable "namespace_include_only" {
  description = "Enable specific AWS services from being monitored. Defaults to all enabled"
  type        = list(string)
  default = [ 
    "api_gateway",
    "application_elb",
    "apprunner",
    "appstream",
    "appsync",
    "athena",
    "auto_scaling",
    "billing",
    "budgeting",
    "certificatemanager",
    "cloudfront",
    "cloudhsm",
    "cloudsearch",
    "cloudwatch_events",
    "cloudwatch_logs",
    "codebuild",
    "cognito",
    "collect_custom_metrics",
    "connect",
    "crawl_alarms",
    "directconnect",
    "dms",
    "documentdb",
    "dynamodb",
    "ebs",
    "ec2",
    "ec2api",
    "ec2spot",
    "ecs",
    "efs",
    "elasticache",
    "elasticbeanstalk",
    "elasticinference",
    "elastictranscoder",
    "elb",
    "emr",
    "es",
    "firehose",
    "fsx",
    "gamelift",
    "glue",
    "inspector",
    "iot",
    "kinesis",
    "kinesis_analytics",
    "kms",
    "lambda",
    "lex",
    "mediaconnect",
    "mediaconvert",
    "mediapackage",
    "mediatailor",
    "ml",
    "mq",
    "msk",
    "nat_gateway",
    "neptune",
    "network_elb",
    "networkfirewall",
    "opsworks",
    "polly",
    "rds",
    "redshift",
    "rekognition",
    "route53",
    "route53resolver",
    "s3",
    "s3storagelens",
    "sagemaker",
    "ses",
    "shield",
    "sns",
    "sqs",
    "step_functions",
    "storage_gateway",
    "swf",
    "transitgateway",
    "translate",
    "trusted_advisor",
    "usage",
    "vpn",
    "waf",
    "wafv2",
    "workspaces",
    "xray"
  ]
}

variable "regions" {
  description = "Regions to be monitored by Datadog."
  default     = null
  type        = list(string) 
}

variable "logs_forwarder_lambdas" {
  description = "Log forwarder lambda arns."
  default     = null
  type        = list(string) 
}

variable "logs_forwarder_sources" {
  description = "Log forwarder resources."
  default     = null
  type        = list(string) 
}

variable "metrics_config_enabled" {
  description = "Enable AWS metrics collection."
  default     = true
  type        = bool 
}

variable "collect_cloudwatch_alarms" {
  description = "Enable CloudWatch alarms collection."
  default     = false
  type        = bool 
}

variable "collect_custom_metrics" {
  description = "Enable custom metrics collection."
  default     = false
  type        = bool 
}

variable "automute_enabled" {
  description = "Enable EC2 automute for AWS metrics."
  default     = true
  type        = bool
}

variable "tag_filters" {
  description = "List of tag filter objects to apply under metrics_config"
  type = list(object({
    namespace = string
    tags      = list(string)
  }))
  default = [{
    namespace = "AWS/EC2"
    tags      = ["com.datadoghq.app:enabled"]
  }]
}

variable "cloud_security_posture_management_collection" {
  description = "Enable Cloud Security Management to scan AWS resources for vulnerabilities, misconfigurations, identity risks, and compliance violations. Requires extended_collection to be set to true."
  default     = false
  type        = bool
}

variable "extended_collection" {
  description = "Whether Datadog collects additional attributes and configuration information about the resources in your AWS account. Required for cloud_security_posture_management_collection."
  default     = true
  type        = bool 
}

variable "xray_services" {
  description = "Include only these services."
  default     = null
  type        = list(string)
}

##################################################################
# Log forwarding stack
##################################################################
variable "datadog_forwarder_use_vpc" {
  description = "Whether to use VPC or not."
  type        = bool
  default     = false
}

variable "datadog_forwarder_vpc_security_group_ids" {
  description = "The VPC security group ids to use. Comma separated list."
  type        = string
  default     = ""
}

variable "datadog_forwarder_vpc_subnet_ids" {
  description = "The VPC subnets to use. Comma separated list."
  type        = string
  default     = ""
}

variable "datadog_forwarder_bucket_subscriptions" {
  description = "Map of bucket names to a pairs of bucket ARN and KMS key ARN. This map is used to configure forwarding logs from the respective buckets to DD."

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

variable "datadog_forwarder_cloudwatch_event_subscriptions" {
  description = "Map of CloudWatch event subscriptions."

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

variable "datadog_forwarder_cloudwatch_log_group_subscriptions" {
  description = "Map of CloudWatch log group subscriptions."

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

variable "datadog_forwarder_include_at_match" {
  description = "Regex pattern on which to filter. if set to empty string, no filtering is applied"
  type        = string
  default     = ""
}

variable "custom_rds_stack_python_version" {
  description = "Python version to use for Lambda Function"
  type        = string
  default     = "python3.7"
}

##################################################################
# RDS forwarding stack
##################################################################
variable "datadog_rds_use_vpc" {
  description = "Whether to use VPC or not."
  type        = bool
  default     = false
}

variable "datadog_rds_vpc_security_group_ids" {
  description = "The VPC security group ids to use. Comma separated list."
  type        = string
  default     = ""
}

variable "datadog_rds_vpc_subnet_ids" {
  description = "The VPC subnets to use. Comma separated list."
  type        = string
  default     = ""
}

variable "datadog_rds_configure_subscription" {
  description = "Whether to enable the CloudWatch log subscription and ship logs to DD"
  type        = bool
  default     = false
}

variable "custom_datadog_rds_stack_template" {
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

variable "datadog_rds_cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group for RDS OS metrics"
  type        = string
  default     = "RDSOSMetrics"
}

variable "datadog_rds_cloudwatch_subscription_filter_pattern" {
  description = "A valid CloudWatch Logs filter pattern for subscribing to a filtered stream of log events."
  type        = string
  default     = ""
}

variable "datadog_rds_cloudwatch_subscription_distribution" {
  description = "The method used to distribute log data to the destination. By default log data is grouped by log stream, but the grouping can be set to random for a more even distribution. This property is only applicable when the destination is an Amazon Kinesis stream. Valid values are \"Random\" and \"ByLogStream\"."
  type        = string
  default     = "Random"
}

variable "datadog_rds_code_s3_object" {
  description = "The bucket object with the lambda function. Source https://github.com/DataDog/datadog-serverless-functions/tree/master/aws/rds_enhanced_monitoring"
  type        = string
  default     = null
}
