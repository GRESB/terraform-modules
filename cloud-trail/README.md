# cloudtrail

Terraform module to setup CloudTrail.

CloudTrail logs calls made to the AWS APIs, and sends those logs to a S3 bucket.
It can additionally also send logs to a CloudWatch log group and to an SNS topic.
When using CloudWatch log groups as destination for its logs, CloudTrail can assume a IAM role that gives it permission to write the logs.
However, when using S3 buckets as destination for the logs, CloudTrail cannot assume a IAM role which means that permission needs to be set on the S3 bucket.
See [CloudTrail IAM docs](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/security-iam.html).

## Examples

This module ships with usage examples.
Please see the [examples directory](./examples):
* [log-to-s3](./examples/log-to-s3)
* [log-to-s3-and-cloudwatch](./examples/log-to-s3-and-cloudwatch)
* [log-to-s3-with-cmk](./examples/log-to-s3-with-cmk)
* [log-to-s3-with-cmk-and-object-locking](./examples/log-to-s3-with-cmk-and-object-locking)
* [log-to-s3-with-s3-kms](./examples/log-to-s3-with-s3-kms)

## Code origin

The code has been forked from https://github.com/cloudposse/terraform-aws-cloudtrail because there were some aspects I wanted to custom (eg. set my own tags on resources).
I first tried to contribute to the original module, but I got no feedback at all on my PRs:
* https://github.com/cloudposse/terraform-aws-cloudtrail/pull/29
* https://github.com/cloudposse/terraform-aws-s3-log-storage/pull/20
* https://github.com/cloudposse/terraform-aws-cloudtrail-s3-bucket/pull/16

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.26.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_log_group.trail_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.aws_cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.aws_cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aws_cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.trail_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.config_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.aws_cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.aws_cloudtrail_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.trail_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#input\_cloudwatch\_log\_group\_arn) | The ARN of a log group, that represents the log group to which CloudTrail logs will be delivered | `string` | `""` | no |
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | The name for the CloudWatch log group created by this module. Leave empty to have a default name set | `string` | `""` | no |
| <a name="input_cloudwatch_log_stream_prefix"></a> [cloudwatch\_log\_stream\_prefix](#input\_cloudwatch\_log\_stream\_prefix) | The prefix for the CloudWatch log stream | `string` | `""` | no |
| <a name="input_cloudwatch_role_arn"></a> [cloudwatch\_role\_arn](#input\_cloudwatch\_role\_arn) | The role for CloudTrail to assume to write to CloudWatch log group | `string` | `""` | no |
| <a name="input_create_cloudwatch_log_group"></a> [create\_cloudwatch\_log\_group](#input\_create\_cloudwatch\_log\_group) | Set to true to create the CloudWatch log group | `bool` | `false` | no |
| <a name="input_create_cloudwatch_role"></a> [create\_cloudwatch\_role](#input\_create\_cloudwatch\_role) | Set to true to create the CloudWatch log group | `bool` | `false` | no |
| <a name="input_create_s3_bucket"></a> [create\_s3\_bucket](#input\_create\_s3\_bucket) | Set to false to not create the bucket | `bool` | `true` | no |
| <a name="input_create_trail"></a> [create\_trail](#input\_create\_trail) | Whether to create the trail | `bool` | `true` | no |
| <a name="input_enable_log_file_validation"></a> [enable\_log\_file\_validation](#input\_enable\_log\_file\_validation) | Whether log file integrity validation is enabled. Creates signed digest for validated contents of logs | `bool` | `true` | no |
| <a name="input_enable_logging"></a> [enable\_logging](#input\_enable\_logging) | Enable logging for the trail | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether to create any resource within this module | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | `"env"` | no |
| <a name="input_event_selector"></a> [event\_selector](#input\_event\_selector) | An event selector for enabling data event logging. See: https://www.terraform.io/docs/providers/aws/r/cloudtrail.html for details on this variable | <pre>list(object({<br/>    include_management_events = bool<br/>    read_write_type           = string<br/><br/>    data_resource = list(object({<br/>      type   = string<br/>      values = list(string)<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_include_global_service_events"></a> [include\_global\_service\_events](#input\_include\_global\_service\_events) | Whether the trail is publishing events from global services such as IAM to the log files | `bool` | `false` | no |
| <a name="input_is_multi_region_trail"></a> [is\_multi\_region\_trail](#input\_is\_multi\_region\_trail) | Whether the trail is created in the current region or in all regions | `bool` | `false` | no |
| <a name="input_is_organization_trail"></a> [is\_organization\_trail](#input\_is\_organization\_trail) | The trail is an AWS Organizations trail | `bool` | `false` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The KMS key ARN to use to encrypt the logs delivered by CloudTrail | `string` | `""` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `"prj"` | no |
| <a name="input_s3_bucket_block_public_access"></a> [s3\_bucket\_block\_public\_access](#input\_s3\_bucket\_block\_public\_access) | Whether to place a block on public access to the S3 bucket | `bool` | `true` | no |
| <a name="input_s3_bucket_force_destroy"></a> [s3\_bucket\_force\_destroy](#input\_s3\_bucket\_force\_destroy) | Force terraform to destroy the trail bucket created by this module when it wants to remove or recrete it | `bool` | `false` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The name of the S3 bucket where to store logs, leve empty to give it the default name | `string` | `""` | no |
| <a name="input_s3_bucket_object_prefix"></a> [s3\_bucket\_object\_prefix](#input\_s3\_bucket\_object\_prefix) | The prefix to use for the log objects stored in the S3 bucket | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be added to resources that support it | `map(string)` | `{}` | no |
| <a name="input_trail_name"></a> [trail\_name](#input\_trail\_name) | The name for the trail, leave empty to have a default name assigned | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_trail_cloudwatch_log_group_name"></a> [trail\_cloudwatch\_log\_group\_name](#output\_trail\_cloudwatch\_log\_group\_name) | n/a |
| <a name="output_trail_name"></a> [trail\_name](#output\_trail\_name) | n/a |
| <a name="output_trail_s3_bucket"></a> [trail\_s3\_bucket](#output\_trail\_s3\_bucket) | n/a |
<!-- END_TF_DOCS -->