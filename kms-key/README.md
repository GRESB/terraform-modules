# kms-key

Terraform module to provision KMS keys

## Usage

```hcl-terraform
module "kms_key" {
  source = "git::https://gitlab.com/open-source-devex/terraform-modules/aws/kms-key.git?ref=v2.0.0"

  key_name        = "my-kms-key"
  key_description = "A KMS key"
  tags            = { environment = "stg" }

  deletion_window_in_days = 30
  enable_key_rotation     = true

  key_policy = [
    {
      principals = [
        {
          type = "AWS", identifiers = [data.aws_caller_identity.current.arn]
        },
        {
          type = "Service", identifiers = ["cloudtrail.amazonaws.com"]
        },
      ]

      effect = "Allow"

      actions = ["kms:GenerateDataKey*"]

      resources = ["*"]

      condition = [
        {
          test     = "StringLike"
          variable = "kms:EncryptionContext:aws:cloudtrail:arn"
          values   = ["arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"]
        }
      ]
    },
  ]
}
```

## Terraform docs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.84.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [random_uuid.name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.final](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.key_management_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.key_usage_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.policy_statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_account_to_manage_key"></a> [allow\_account\_to\_manage\_key](#input\_allow\_account\_to\_manage\_key) | Whether to create a key policy that allows the account to manage access to the key via IAM policies. See AWS docs for more details https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html#key-policy-default-allow-root-enable-iam. | `bool` | `false` | no |
| <a name="input_customer_master_key_spec"></a> [customer\_master\_key\_spec](#input\_customer\_master\_key\_spec) | The type of key material to use for the CMK. Valid values: SYMMETRIC\_DEFAULT, RSA\_2048, RSA\_3072, RSA\_4096, HMAC\_256, ECC\_NIST\_P256, ECC\_NIST\_P384, ECC\_NIST\_P521, or ECC\_SECG\_P256K1 | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. | `number` | `30` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | Specifies whether key rotation is enabled | `bool` | `true` | no |
| <a name="input_key_description"></a> [key\_description](#input\_key\_description) | The description for the key | `string` | `null` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The value set on the Name tag | `string` | `null` | no |
| <a name="input_key_policy"></a> [key\_policy](#input\_key\_policy) | Statements for the key policy. | <pre>list(object({<br/>    principals = list(object({<br/>      type = string, identifiers = list(string)<br/>    }))<br/>    effect    = string<br/>    actions   = list(string)<br/>    resources = optional(list(string))<br/>    condition = optional(list(object({<br/>      test     = string<br/>      variable = string<br/>      values   = list(string)<br/>    })))<br/>  }))</pre> | `[]` | no |
| <a name="input_key_policy_json"></a> [key\_policy\_json](#input\_key\_policy\_json) | Policy JSON for the key. | `string` | `""` | no |
| <a name="input_key_usage"></a> [key\_usage](#input\_key\_usage) | The intended use of the key. Valid values: ENCRYPT\_DECRYPT, SIGN\_VERIFY or GENERATE\_VERIFY\_MAC | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be added to resources that support it | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_alias_arn"></a> [key\_alias\_arn](#output\_key\_alias\_arn) | n/a |
| <a name="output_key_alias_name"></a> [key\_alias\_name](#output\_key\_alias\_name) | n/a |
| <a name="output_key_arn"></a> [key\_arn](#output\_key\_arn) | n/a |
| <a name="output_key_id"></a> [key\_id](#output\_key\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
