# guard-duty

Terraform module to setup AWS GuardDuty.

This module is forked from a [similar module](https://github.com/cmdlabs/terraform-aws-guardduty) with the difference that this module's interface is inline with the other
 modules of this collection, and it offers the ability to pass in resources like S3 bucket instead of creating them within the module.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.25.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_guardduty_detector.detector](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector) | resource |
| [aws_guardduty_invite_accepter.member_accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_invite_accepter) | resource |
| [aws_guardduty_ipset.ipset](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_ipset) | resource |
| [aws_guardduty_member.members](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_member) | resource |
| [aws_guardduty_member.organizations_members](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_member) | resource |
| [aws_guardduty_organization_configuration.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_organization_configuration) | resource |
| [aws_guardduty_threatintelset.threatintelset](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_threatintelset) | resource |
| [aws_s3_bucket.created](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.created](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_ownership_controls.created](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_public_access_block.created_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_object.ipset](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.threatintelset](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_activate_ipset"></a> [activate\_ipset](#input\_activate\_ipset) | Whether to have GuardDuty start using the uploaded IPSet | `bool` | `true` | no |
| <a name="input_activate_threatintelset"></a> [activate\_threatintelset](#input\_activate\_threatintelset) | Whether to have GuardDuty start using the uploaded ThreatIntelSet | `bool` | `true` | no |
| <a name="input_auto_enable_organization_members"></a> [auto\_enable\_organization\_members](#input\_auto\_enable\_organization\_members) | Indicates the auto-enablement configuration of GuardDuty for the member accounts in the organization. | `string` | `"ALL"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The region where the trail bucket or the log group is created, will default to the region of the provider when lefts empty. | `string` | `""` | no |
| <a name="input_create_s3_bucket"></a> [create\_s3\_bucket](#input\_create\_s3\_bucket) | Whether to create an S3 bucket to hold lists of IPs | `bool` | `true` | no |
| <a name="input_detector_frequency"></a> [detector\_frequency](#input\_detector\_frequency) | Specifies the frequency of notifications sent for subsequent finding occurrences. If the detector is a GuardDuty member account, the value is determined by the GuardDuty master account and cannot be modified, otherwise defaults to SIX\_HOURS. For standalone and GuardDuty master accounts, it must be configured in Terraform to enable drift detection. Valid values for standalone and master accounts: FIFTEEN\_MINUTES, ONE\_HOUR, SIX\_HOURS. | `string` | `"SIX_HOURS"` | no |
| <a name="input_enable_detector"></a> [enable\_detector](#input\_enable\_detector) | Whether to enable monitoring and feedback reporting | `bool` | `true` | no |
| <a name="input_enable_organization"></a> [enable\_organization](#input\_enable\_organization) | Whether to control guardduty from the aws organization. | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether to create any resource within this module | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | `"env"` | no |
| <a name="input_ipset_format"></a> [ipset\_format](#input\_ipset\_format) | The format of the file that contains the IPSet | `string` | `"TXT"` | no |
| <a name="input_ipset_iplist"></a> [ipset\_iplist](#input\_ipset\_iplist) | IPSet list of trusted IP addresses | `list(string)` | `[]` | no |
| <a name="input_is_guardduty_master"></a> [is\_guardduty\_master](#input\_is\_guardduty\_master) | Whether the account is a master account | `bool` | `false` | no |
| <a name="input_is_guardduty_member"></a> [is\_guardduty\_member](#input\_is\_guardduty\_member) | Whether the account is a member account | `bool` | `false` | no |
| <a name="input_master_account_id"></a> [master\_account\_id](#input\_master\_account\_id) | Account ID for Guard Duty Master. Required if is\_guardduty\_member | `string` | `""` | no |
| <a name="input_member_list"></a> [member\_list](#input\_member\_list) | The list of member accounts to be added. Each member list need to have values of account\_id, member\_email and invite boolean | <pre>list(object({<br/>    account_id   = string<br/>    member_email = string<br/>    invite       = bool<br/>  }))</pre> | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `"prj"` | no |
| <a name="input_s3_bucket_block_public_access"></a> [s3\_bucket\_block\_public\_access](#input\_s3\_bucket\_block\_public\_access) | Whether to place a block on public access to the created S3 bucket | `bool` | `true` | no |
| <a name="input_s3_bucket_force_destroy"></a> [s3\_bucket\_force\_destroy](#input\_s3\_bucket\_force\_destroy) | Allow terraform to destroy the bucket created by this module when it wants to remove or recrete it | `bool` | `false` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | The name of the S3 bucket where lists of IPs will be stored. Leave empty to assign default name | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be added to resources that support it | `map(string)` | `{}` | no |
| <a name="input_threatintelset_format"></a> [threatintelset\_format](#input\_threatintelset\_format) | The format of the file that contains the ThreatIntelSet | `string` | `"TXT"` | no |
| <a name="input_threatintelset_iplist"></a> [threatintelset\_iplist](#input\_threatintelset\_iplist) | ThreatIntelSet list of known malicious IP addresses | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | The AWS account ID of the GuardDuty detector |
| <a name="output_detector_id"></a> [detector\_id](#output\_detector\_id) | The ID of the GuardDuty detector |
<!-- END_TF_DOCS -->