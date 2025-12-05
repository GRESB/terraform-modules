# #########################################
# Module Configuration
# #########################################
variable "bucket_name" {
  description = "The name of the bucket."
  type        = string
}

variable "bucket_acl" {
  description = "The ACL to apply on the bucket."
  type        = string
  default     = "private"
}

variable "bucket_policy" {
  description = "The S3 bucket policy to apply to the bucket. If `prevent_unencrypted_uploads` is true, this will be merged with the policy that prevents unencrypted uploads."
  type        = string
  default     = ""
}

variable "prevent_unencrypted_uploads" {
  description = "Whether to configure the bucket to prevent upload of unencrypted objects."
  type        = bool
  default     = true
}

variable "kms_deletion_window" {
  description = "The KMS key deletion window."
  type        = number
  default     = 10
}

variable "users" {
  description = "List of IAM user ARNs to which the appropriate policies will be attached so they gain access to the backend."
  type        = list(string)
  default     = []

  validation {
    # user_arn should not contain wildcard '*'
    condition = alltrue([for user_arn in var.users : (length(regexall("[*]", user_arn)) == 0)])

    error_message = "User ARN cannot contain wildcard '*'."
  }
}

variable "roles" {
  description = "List of IAM roles ARNs to which the appropriate policies will be attached so they gain access to the backend."
  type        = list(string)
  default     = []

  validation {
    # role_arn should not contain wildcard '*'
    condition = alltrue([for role_arn in var.roles : (length(regexall("[*]", role_arn)) == 0)])

    error_message = "Role ARN cannot contain wildcard '*'."
  }
}

variable "common_tags" {
  description = "Tags to apply on all resources."
  type        = map(string)
  default     = {}
}

variable "create_dynamo_lock_table" {
  description = "Whether to create a DynamoDB table for locking state files."
  type        = bool
  default     = true
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Whether terraform should attempt to destroy the S3 bucket even when it isn't empty."
  type        = bool
  default     = false
}

variable "generate_remote_state_config_file" {
  description = "Whether terraform should generate backend config as yaml."
  type        = bool
  default     = false
}

variable "remote_state_config_file_path" {
  description = "Where the remote state config should be stored."
  type        = string
  default     = "remote-state-config.yaml"
}

variable "allow_account_to_manage_kms_key" {
  description = "Whether to create a KMS key policy that allows the account to manage access to the key via IAM policies. See AWS docs for more details https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html#key-policy-default-allow-root-enable-iam."
  type        = bool
  default     = false
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
