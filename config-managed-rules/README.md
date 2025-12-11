# config-managed-rules

Terraform module to setup AWS Config managed rules https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html

AWS Config requires permissions to access the S3 bucket where it will store its logs, and an SNS topic where it sends notifications.
The module can create a default S3 bucket for the logs with permissions setup for AWS Config.
This module sets up an IAM role with policies to provide access to the S3 bucket that is provided as an argument to the module or the bucket the module creates.
See https://docs.aws.amazon.com/config/latest/developerguide/iamrole-permissions.html for the required permissions.

AWS Config does not work if (1) object level locking is enabled on the S3 bucket.
In order to use a KMS Customer Master Key the policy on the key needs to allow AWS Config to generate a data key. See [example with CMK for how to do that](./examples/complete-with-cmk/test-main.tf). 

AWS Config is able to record and aggregate logs from different accounts, across all regions.
Use this module in the account that will aggregate the logs, set `enable_aggregation = true` and pass the IDs for the other accounts in via `aggregated_accounts = ["222222222222"]`.
To configure the other accounts to allow collection of resource logs from the aggregator account use the `aws_config_aggregate_authorization` resource to establish trust between the accounts.
```hcl
resource "aws_config_aggregate_authorization" "example" {
  account_id = "11111111111"  # id of account where logs will be aggregated
  region     = "eu-west-1"
}
```


## Custom policy template files

Certain checks (like the IAM user password) are configured with a policy document that specified the compliance rules to be checked. 
This module offers default templates for that, but in case users wants to provide their own templates they can pass in a path to a directory where the templates will be found.
Setting `custom_policy_templates_path = <path>` will make the module look for templates in that path.
The module will expect to find the following templates:
* `iam-user-password-policy.json.tpl` to configure the IAM user password policy check. https://docs.aws.amazon.com/config/latest/developerguide/iam-password-policy.html
 

## Backlog test cross account aggregation
This needs more than one account.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.26.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_config_config_rule.cloudtrail_encryption_is_enabled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule) | resource |
| [aws_config_config_rule.cloudtrail_is_enabled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule) | resource |
| [aws_config_config_rule.cloudtrail_log_validation_is_enabled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule) | resource |
| [aws_config_config_rule.cloudtrail_multi_region_is_enabled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule) | resource |
| [aws_config_config_rule.ec2_instances_deployed_to_vpcs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule) | resource |
| [aws_config_config_rule.ec2_volumes_in_use](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule) | resource |
| [aws_config_config_rule.iam_groups_have_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule) | resource |
| [aws_config_config_rule.iam_user_password_compliance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule) | resource |
| [aws_config_config_rule.iam_users_no_direct_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule) | resource |
| [aws_config_config_rule.s3_bucket_encryption_enabled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule) | resource |
| [aws_config_config_rule.s3_bucket_public_read_prohibited](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule) | resource |
| [aws_config_config_rule.s3_bucket_public_write_prohibited](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule) | resource |
| [aws_config_config_rule.s3_bucket_ssl_request_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule) | resource |
| [aws_config_configuration_aggregator.account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_aggregator) | resource |
| [aws_config_configuration_aggregator.organization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_aggregator) | resource |
| [aws_config_configuration_recorder.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder) | resource |
| [aws_config_configuration_recorder_status.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder_status) | resource |
| [aws_config_delivery_channel.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_delivery_channel) | resource |
| [aws_iam_policy.s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.aws_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.organization_aggregator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.managed_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.organization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.config_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.config_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.aws_config_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.combined_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.organization_aggregator_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aggregated_accounts"></a> [aggregated\_accounts](#input\_aggregated\_accounts) | List of the account IDs from where the aggregator should pull data | `list(string)` | `[]` | no |
| <a name="input_aggregator_name"></a> [aggregator\_name](#input\_aggregator\_name) | The name for the AWS Config aggregator, leave empty to use the default name | `string` | `""` | no |
| <a name="input_aws_config_kms_arns"></a> [aws\_config\_kms\_arns](#input\_aws\_config\_kms\_arns) | The arns of (cross account) kms keys to trust. | `list(string)` | `[]` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The region where the config bucket is created, will default to the region of the provider when lefts empty. | `string` | `""` | no |
| <a name="input_bucket_block_public_access"></a> [bucket\_block\_public\_access](#input\_bucket\_block\_public\_access) | Whether to place a block on public access to the S3 bucket | `bool` | `true` | no |
| <a name="input_bucket_force_destroy"></a> [bucket\_force\_destroy](#input\_bucket\_force\_destroy) | Force terraform to destroy the config bucket created by this module when it wants to remove or recrete it | `bool` | `false` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket where to store logs, leve empty to give it the default name | `string` | `""` | no |
| <a name="input_bucket_object_prefix"></a> [bucket\_object\_prefix](#input\_bucket\_object\_prefix) | The prefix to use for the log objects stored in the S3 bucket | `string` | `""` | no |
| <a name="input_check_cloudtrail_is_enabled"></a> [check\_cloudtrail\_is\_enabled](#input\_check\_cloudtrail\_is\_enabled) | Set to false to disable the check for CloudTrail enabled | `bool` | `true` | no |
| <a name="input_check_cloudtrail_is_encryption_enabled"></a> [check\_cloudtrail\_is\_encryption\_enabled](#input\_check\_cloudtrail\_is\_encryption\_enabled) | Set to false to disable the check for CloudTrail encryption enabled | `bool` | `true` | no |
| <a name="input_check_cloudtrail_is_log_validation_enabled"></a> [check\_cloudtrail\_is\_log\_validation\_enabled](#input\_check\_cloudtrail\_is\_log\_validation\_enabled) | Set to false to disable the check for CloudTrail log validation enabled | `bool` | `true` | no |
| <a name="input_check_cloudtrail_is_multi_region_enabled"></a> [check\_cloudtrail\_is\_multi\_region\_enabled](#input\_check\_cloudtrail\_is\_multi\_region\_enabled) | Set to false to disable the check for CloudTrail multi-region enabled | `bool` | `true` | no |
| <a name="input_check_ec2_instances_deployed_to_vpcs"></a> [check\_ec2\_instances\_deployed\_to\_vpcs](#input\_check\_ec2\_instances\_deployed\_to\_vpcs) | Set to false to disable the check for EC2 deployed to VPCs | `bool` | `true` | no |
| <a name="input_check_ec2_volumes_in_use"></a> [check\_ec2\_volumes\_in\_use](#input\_check\_ec2\_volumes\_in\_use) | Set to false to disable the check for EC2 volumes in use | `bool` | `true` | no |
| <a name="input_check_iam_groups_have_users"></a> [check\_iam\_groups\_have\_users](#input\_check\_iam\_groups\_have\_users) | Set to false to disable the check for IAM groups having users | `bool` | `true` | no |
| <a name="input_check_iam_user_passwords"></a> [check\_iam\_user\_passwords](#input\_check\_iam\_user\_passwords) | Set to false to disable the check for IAM user password compliance | `bool` | `true` | no |
| <a name="input_check_iam_users_no_direct_policy"></a> [check\_iam\_users\_no\_direct\_policy](#input\_check\_iam\_users\_no\_direct\_policy) | Set to false to disable the check for IAM user having no policies directly attached | `bool` | `true` | no |
| <a name="input_check_s3_bucket_is_encryption_enabled"></a> [check\_s3\_bucket\_is\_encryption\_enabled](#input\_check\_s3\_bucket\_is\_encryption\_enabled) | Set to false to disable the check for S3 buckets having server side encryption enabled | `bool` | `true` | no |
| <a name="input_check_s3_bucket_public_read_prohibited"></a> [check\_s3\_bucket\_public\_read\_prohibited](#input\_check\_s3\_bucket\_public\_read\_prohibited) | Set to false to disable the check for S3 buckets not allowing public read access | `bool` | `true` | no |
| <a name="input_check_s3_bucket_public_write_prohibited"></a> [check\_s3\_bucket\_public\_write\_prohibited](#input\_check\_s3\_bucket\_public\_write\_prohibited) | Set to false to disable the check for S3 buckets not allowing public write access | `bool` | `true` | no |
| <a name="input_check_s3_bucket_ssl_request_only"></a> [check\_s3\_bucket\_ssl\_request\_only](#input\_check\_s3\_bucket\_ssl\_request\_only) | Set to false to disable the check for S3 buckets not allowing unencrypted (non SSL) requests | `bool` | `true` | no |
| <a name="input_config_delivery_frequency"></a> [config\_delivery\_frequency](#input\_config\_delivery\_frequency) | The frequency with which AWS Config delivers configuration snapshots. | `string` | `"Six_Hours"` | no |
| <a name="input_config_max_execution_frequency"></a> [config\_max\_execution\_frequency](#input\_config\_max\_execution\_frequency) | The maximum frequency with which AWS Config runs evaluations for a rule, if the rule is triggered at a periodic frequency. Valid values: One\_Hour, Three\_Hours, Six\_Hours, Twelve\_Hours, or TwentyFour\_Hours. | `string` | `"TwentyFour_Hours"` | no |
| <a name="input_create_bucket"></a> [create\_bucket](#input\_create\_bucket) | Set to true to create the bucket | `bool` | `false` | no |
| <a name="input_create_recorder"></a> [create\_recorder](#input\_create\_recorder) | Whether to create the recorder and delivery channel resources (which have to be unique per account) | `bool` | `true` | no |
| <a name="input_custom_policy_templates_path"></a> [custom\_policy\_templates\_path](#input\_custom\_policy\_templates\_path) | Path to a directotry containing policy templates, leave empty to use default templates bundled with module | `string` | `""` | no |
| <a name="input_delivery_channel_name"></a> [delivery\_channel\_name](#input\_delivery\_channel\_name) | The name for the AWS Config delivery channel, leave empty to use the default name | `string` | `""` | no |
| <a name="input_enable_aggregation"></a> [enable\_aggregation](#input\_enable\_aggregation) | Set to true to setup aggregation of inventory and compliancy across multiple acounts | `bool` | `false` | no |
| <a name="input_enable_organization"></a> [enable\_organization](#input\_enable\_organization) | Set to true to setup aggregation accross an organization | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether to create any resource within this module | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | `"env"` | no |
| <a name="input_iam_service_role_name"></a> [iam\_service\_role\_name](#input\_iam\_service\_role\_name) | The name for the IAM role assumed by AWs Config, leave empty to use the default name | `string` | `""` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `"prj"` | no |
| <a name="input_recorder_name"></a> [recorder\_name](#input\_recorder\_name) | The name for the AWS Config recorder, leave empty to use the default name | `string` | `""` | no |
| <a name="input_recording_enabled"></a> [recording\_enabled](#input\_recording\_enabled) | Set to false to stop recording | `bool` | `true` | no |
| <a name="input_rule_iam_password_check_expires"></a> [rule\_iam\_password\_check\_expires](#input\_rule\_iam\_password\_check\_expires) | n/a | `bool` | `false` | no |
| <a name="input_rule_iam_password_max_age_in_days"></a> [rule\_iam\_password\_max\_age\_in\_days](#input\_rule\_iam\_password\_max\_age\_in\_days) | n/a | `number` | `-1` | no |
| <a name="input_rule_iam_password_min_length"></a> [rule\_iam\_password\_min\_length](#input\_rule\_iam\_password\_min\_length) | n/a | `number` | `60` | no |
| <a name="input_rule_iam_password_number_of_passwords_tracked"></a> [rule\_iam\_password\_number\_of\_passwords\_tracked](#input\_rule\_iam\_password\_number\_of\_passwords\_tracked) | n/a | `number` | `10` | no |
| <a name="input_rule_iam_password_required_lowercase"></a> [rule\_iam\_password\_required\_lowercase](#input\_rule\_iam\_password\_required\_lowercase) | n/a | `bool` | `true` | no |
| <a name="input_rule_iam_password_required_numbers"></a> [rule\_iam\_password\_required\_numbers](#input\_rule\_iam\_password\_required\_numbers) | n/a | `bool` | `true` | no |
| <a name="input_rule_iam_password_required_symbols"></a> [rule\_iam\_password\_required\_symbols](#input\_rule\_iam\_password\_required\_symbols) | n/a | `bool` | `true` | no |
| <a name="input_rule_iam_password_required_uppercase"></a> [rule\_iam\_password\_required\_uppercase](#input\_rule\_iam\_password\_required\_uppercase) | ############################################################## Managed rule configuration ############################################################## | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be added to resources that support it | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_password_check_policy"></a> [iam\_password\_check\_policy](#output\_iam\_password\_check\_policy) | n/a |
<!-- END_TF_DOCS -->