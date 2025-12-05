variable "s3_bucket_name" {
  description = "The state bucket name."
  type = string
}

variable "cmk_key_arn" {
  description = "The ARN of the CMK."
  type = string
}

variable "cmk_key_alias_arn" {
  description = "The ARN of the CMK alias."
  type = string
}

variable "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table."
  type = string
}

variable "path_based_permissions" {
  description = "Configuration for assigning path based permissions to users and roles. Each element's `principal_type` is either `user` or `role, `principal_name` is the respective name, `paths` is a of paths in the S3 bucket possibly containing `*` wildcards, `action` is either `read` or `read-write`."
  type = map(object({
    principal_type = string
    principal_name = string
    paths          = list(string)
    action         = string
  }))

  default = {}

  validation {
    condition = alltrue(flatten([for item in var.path_based_permissions : [
      contains(["user", "role"], item.principal_type),
      contains(["read", "read-write"], item.action),
      item.principal_name != "",
      length(item.paths) > 0]
    ]))
    error_message = "Invalid path based permission item."
  }
}
