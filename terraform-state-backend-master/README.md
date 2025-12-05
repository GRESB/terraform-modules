# Terraform State Backend

This terraform module allows you to setup a backend for your terraform projects that includes:

* `s3-bucket`, for storing state files
* `dynamo-db`, for offering state file lock capabilities
* `kms`, the key created will be used for bucket objects encryption

This module includes a submodule that creates path based permissions for the terraform state backend.

## Module usage

```hcl
module "state_backend" {
  source = "git::https://gitlab.com/open-source-devex/terraform-modules/aws/terraform-state-backend?ref=v5.0.0"

  bucket_name = var.bucket_name
  bucket_acl  = "private"

  create_dynamo_lock_table = true

  common_tags = {
    foo = "bar"
  }

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true

  prevent_unencrypted_uploads = true

  kms_deletion_window = 7

  users = [aws_iam_user.test_user.arn]
  roles = [aws_iam_role.test_role.arn]
}
```

Multiple state files can be supported via this module. Each state file will be created in S3 under the key configured in the terraform backend and each of those will have an entry in the DynamoDb table also using the same key.

## Terraform docs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.45.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.2.3 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cmk"></a> [cmk](#module\_cmk) | git::https://gitlab.com/open-source-devex/terraform-modules/aws/kms-key.git | v2.0.2 |
| <a name="module_path_based_permissions"></a> [path\_based\_permissions](#module\_path\_based\_permissions) | ./modules/path-based-permissions | n/a |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | 3.6.0 |

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.tf_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_policy.tf_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.tf_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.tf_backend](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [local_file.generate_remote_state_config_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.create_remote_state_config_path](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.prevent_unencrypted_uploads](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.tf_backend_full_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_account_to_manage_kms_key"></a> [allow\_account\_to\_manage\_kms\_key](#input\_allow\_account\_to\_manage\_kms\_key) | Whether to create a KMS key policy that allows the account to manage access to the key via IAM policies. See AWS docs for more details https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html#key-policy-default-allow-root-enable-iam. | `bool` | `false` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_bucket_acl"></a> [bucket\_acl](#input\_bucket\_acl) | The ACL to apply on the bucket. | `string` | `"private"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the bucket. | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Tags to apply on all resources. | `map(string)` | `{}` | no |
| <a name="input_create_dynamo_lock_table"></a> [create\_dynamo\_lock\_table](#input\_create\_dynamo\_lock\_table) | Whether to create a DynamoDB table for locking state files. | `bool` | `true` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether terraform should attempt to destroy the S3 bucket even when it isn't empty. | `bool` | `false` | no |
| <a name="input_generate_remote_state_config_file"></a> [generate\_remote\_state\_config\_file](#input\_generate\_remote\_state\_config\_file) | Whether terraform should generate backend config as yaml. | `bool` | `false` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_kms_deletion_window"></a> [kms\_deletion\_window](#input\_kms\_deletion\_window) | The KMS key deletion window. | `number` | `10` | no |
| <a name="input_path_based_permissions"></a> [path\_based\_permissions](#input\_path\_based\_permissions) | Configuration for assigning path based permissions to users and roles. Each element's `principal_type` is either `user` or `role, `principal\_name` is the respective name, `paths` is a of paths in the S3 bucket possibly containing `*` wildcards, `action` is either `read` or `read-write`.` | <pre>map(object({<br>    principal_type = string<br>    principal_name = string<br>    paths          = list(string)<br>    action         = string<br>  }))</pre> | `{}` | no |
| <a name="input_prevent_unencrypted_uploads"></a> [prevent\_unencrypted\_uploads](#input\_prevent\_unencrypted\_uploads) | Whether to configure the bucket to prevent upload of unencrypted objects. | `bool` | `true` | no |
| <a name="input_remote_state_config_file_path"></a> [remote\_state\_config\_file\_path](#input\_remote\_state\_config\_file\_path) | Where the remote state config should be stored. | `string` | `"remote-state-config.yaml"` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | List of IAM roles ARNs to which the appropriate policies will be attached so they gain access to the backend. | `list(string)` | `[]` | no |
| <a name="input_users"></a> [users](#input\_users) | List of IAM user ARNs to which the appropriate policies will be attached so they gain access to the backend. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_iam_policy_arn"></a> [aws\_iam\_policy\_arn](#output\_aws\_iam\_policy\_arn) | n/a |
| <a name="output_aws_iam_policy_name"></a> [aws\_iam\_policy\_name](#output\_aws\_iam\_policy\_name) | n/a |
| <a name="output_remote_state_config"></a> [remote\_state\_config](#output\_remote\_state\_config) | n/a |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | n/a |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | n/a |
| <a name="output_s3_bucket_kms_key_alias_arn"></a> [s3\_bucket\_kms\_key\_alias\_arn](#output\_s3\_bucket\_kms\_key\_alias\_arn) | n/a |
| <a name="output_s3_bucket_kms_key_alias_name"></a> [s3\_bucket\_kms\_key\_alias\_name](#output\_s3\_bucket\_kms\_key\_alias\_name) | n/a |
| <a name="output_s3_bucket_kms_key_arn"></a> [s3\_bucket\_kms\_key\_arn](#output\_s3\_bucket\_kms\_key\_arn) | n/a |
| <a name="output_s3_bucket_kms_key_id"></a> [s3\_bucket\_kms\_key\_id](#output\_s3\_bucket\_kms\_key\_id) | n/a |
| <a name="output_s3_bucket_lock_table_id"></a> [s3\_bucket\_lock\_table\_id](#output\_s3\_bucket\_lock\_table\_id) | n/a |
| <a name="output_s3_bucket_lock_table_name"></a> [s3\_bucket\_lock\_table\_name](#output\_s3\_bucket\_lock\_table\_name) | n/a |
| <a name="output_s3_bucket_region"></a> [s3\_bucket\_region](#output\_s3\_bucket\_region) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
