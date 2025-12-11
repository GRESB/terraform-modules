# Log Forwarder Bucket Subscription

Provision a subscription for an S3 Bucket with logs to be forwarded to Datadog.

## Terraform docs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.33 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.bucket_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.bucket_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.datadog_forwarder_lambda_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_permission.bucket_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket_notification.bucket_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_iam_policy_document.bucket_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_datadog_forwarder_function_arn"></a> [datadog\_forwarder\_function\_arn](#input\_datadog\_forwarder\_function\_arn) | The ARN of the DD forwarder stack lambda | `string` | n/a | yes |
| <a name="input_datadog_forwarder_function_name"></a> [datadog\_forwarder\_function\_name](#input\_datadog\_forwarder\_function\_name) | The name of the DD forwarder stack lambda | `string` | n/a | yes |
| <a name="input_datadog_forwarder_iam_role_name"></a> [datadog\_forwarder\_iam\_role\_name](#input\_datadog\_forwarder\_iam\_role\_name) | The name of the IAM role for DataDog | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for all resources that will take them | `string` | `""` | no |
| <a name="input_subscriptions"></a> [subscriptions](#input\_subscriptions) | Map of bucket names to a pairs of bucket ARN and KMS key ARN. This map is used to configure forwarding logs from the respective bucekts to DD. | <pre>map(object({<br>    bucket_arn   = string<br>    is_encrypted = bool<br>    kms_key_arn  = string<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags appended to all resources that will take them | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subscription_kms_keys"></a> [subscription\_kms\_keys](#output\_subscription\_kms\_keys) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
