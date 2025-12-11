variable project {
  type    = string
  default = "prj"
}

variable environment {
  type    = string
  default = "env"
}

variable "tags" {
  description = "Tags to be added to resources that support it"
  type        = map(string)
  default     = {}
}

variable "enabled" {
  description = "Whether to create any resource within this module"
  type        = bool
  default     = true
}

variable trail_name {
  description = "The name for the trail, leave empty to have a default name assigned"
  type        = string
  default     = ""
}

variable "create_trail" {
  description = "Whether to create the trail"
  type        = bool
  default     = true
}

variable "create_s3_bucket" {
  description = "Set to false to not create the bucket"
  type        = bool
  default     = true
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket where to store logs, leve empty to give it the default name"
  type        = string
  default     = ""
}

variable "s3_bucket_object_prefix" {
  description = "The prefix to use for the log objects stored in the S3 bucket"
  type        = string
  default     = ""
}

variable "s3_bucket_force_destroy" {
  description = "Force terraform to destroy the trail bucket created by this module when it wants to remove or recrete it"
  type        = bool
  default     = false
}

variable "s3_bucket_block_public_access" {
  description = "Whether to place a block on public access to the S3 bucket"
  type        = bool
  default     = true
}

variable "create_cloudwatch_log_group" {
  description = "Set to true to create the CloudWatch log group"
  type        = bool
  default     = false
}

variable "cloudwatch_log_group_name" {
  description = "The name for the CloudWatch log group created by this module. Leave empty to have a default name set"
  type        = string
  default     = ""
}

variable "cloudwatch_log_group_arn" {
  description = "The ARN of a log group, that represents the log group to which CloudTrail logs will be delivered"
  type        = string
  default     = ""
}

variable "create_cloudwatch_role" {
  description = "Set to true to create the CloudWatch log group"
  type        = bool
  default     = false
}

variable "cloudwatch_role_arn" {
  description = "The role for CloudTrail to assume to write to CloudWatch log group"
  type        = string
  default     = ""
}

variable "cloudwatch_log_stream_prefix" {
  description = "The prefix for the CloudWatch log stream"
  type        = string
  default     = ""
}

variable "kms_key_arn" {
  description = "The KMS key ARN to use to encrypt the logs delivered by CloudTrail"
  type        = string
  default     = ""
}

#####################
# Trail configuration
#####################
variable "enable_log_file_validation" {
  description = "Whether log file integrity validation is enabled. Creates signed digest for validated contents of logs"
  type        = bool
  default     = true
}

variable "is_multi_region_trail" {
  description = "Whether the trail is created in the current region or in all regions"
  type        = bool
  default     = false
}

variable "is_organization_trail" {
  description = "The trail is an AWS Organizations trail"
  type        = bool
  default     = false
}

variable "include_global_service_events" {
  description = "Whether the trail is publishing events from global services such as IAM to the log files"
  type        = bool
  default     = false
}

variable "enable_logging" {
  description = "Enable logging for the trail"
  type        = bool
  default     = true
}

variable "event_selector" {
  description = "An event selector for enabling data event logging. See: https://www.terraform.io/docs/providers/aws/r/cloudtrail.html for details on this variable"

  type = list(object({
    include_management_events = bool
    read_write_type           = string

    data_resource = list(object({
      type   = string
      values = list(string)
    }))
  }))

  default = []
}

