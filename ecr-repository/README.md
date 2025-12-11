# ecr-repository

Terraform module to create an ECR repository

## Usage

```hcl-terraform
module "ecr" {
  source = "git::https://gitlab.com/open-source-devex/terraform-modules/aws/ecr-repository.git?ref=v2.0.1"

  project     = "open-source-devex"
  environment = "test"

  name                 = "my-ecr"
  image_tag_mutability = "IMMUTABLE"

  ecr_lifecycle_policy = <<EOD
{
  "rules": [
    {
      "rulePriority": 3,
      "description": "Expire untagged images older than 15 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 15
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOD

  read_only_access_accounts = ["652582332630"]
  read_only_access_services = ["cloudtrail.amazonaws.com"]

  full_access_accounts = ["652582332630"]
  full_access_services = ["codebuild.amazonaws.com"]
}
```

## Terraform docs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_iam_policy_document.full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.read_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ecr_lifecycle_policy"></a> [ecr\_lifecycle\_policy](#input\_ecr\_lifecycle\_policy) | Rules to be added to the ECR lifecycle policy. | `string` | `"{\n  \"rules\": [\n    {\n      \"rulePriority\": 1,\n        \"description\": \"Keep last 10 final releases\",\n        \"selection\": {\n          \"tagStatus\": \"tagged\",\n          \"tagPrefixList\": [\"v\"],\n          \"countType\": \"imageCountMoreThan\",\n          \"countNumber\": 10\n        },\n        \"action\": {\n          \"type\": \"expire\"\n        }\n    },\n    {\n      \"rulePriority\": 2,\n      \"description\": \"Keep last 30 release candidates\",\n      \"selection\": {\n        \"tagStatus\": \"tagged\",\n        \"tagPrefixList\": [\"RC\"],\n        \"countType\": \"imageCountMoreThan\",\n        \"countNumber\": 30\n      },\n      \"action\": {\n        \"type\": \"expire\"\n      }\n    },\n    {\n      \"rulePriority\": 3,\n      \"description\": \"Expire untagged images older than 15 days\",\n      \"selection\": {\n        \"tagStatus\": \"untagged\",\n        \"countType\": \"sinceImagePushed\",\n        \"countUnit\": \"days\",\n        \"countNumber\": 15\n      },\n      \"action\": {\n        \"type\": \"expire\"\n      }\n    }\n  ]\n}\n"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment to which the resources belong. | `string` | n/a | yes |
| <a name="input_full_access_accounts"></a> [full\_access\_accounts](#input\_full\_access\_accounts) | AWS accounts that should have full access to the repository. | `list(string)` | `[]` | no |
| <a name="input_full_access_roles"></a> [full\_access\_roles](#input\_full\_access\_roles) | AWS role ARNs that should have full access to the repository. | `list(string)` | `[]` | no |
| <a name="input_full_access_services"></a> [full\_access\_services](#input\_full\_access\_services) | AWS services that should have full access to the repository. | `list(string)` | `[]` | no |
| <a name="input_full_access_users"></a> [full\_access\_users](#input\_full\_access\_users) | AWS user ARNs that should have full access to the repository. | `list(string)` | `[]` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. | `string` | `"MUTABLE"` | no |
| <a name="input_kms_cmk_arn"></a> [kms\_cmk\_arn](#input\_kms\_cmk\_arn) | The ARN of a KMS CMK to use for encryption at rest in the repository. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the repository to be created. | `string` | `""` | no |
| <a name="input_project"></a> [project](#input\_project) | The name of the project to which the resources belong | `string` | n/a | yes |
| <a name="input_read_only_access_accounts"></a> [read\_only\_access\_accounts](#input\_read\_only\_access\_accounts) | AWS accounts IDs that should have read only access to the repository. | `list(string)` | `[]` | no |
| <a name="input_read_only_access_roles"></a> [read\_only\_access\_roles](#input\_read\_only\_access\_roles) | AWS role ARNs that should have read only access to the repository. | `list(string)` | `[]` | no |
| <a name="input_read_only_access_services"></a> [read\_only\_access\_services](#input\_read\_only\_access\_services) | AWS services that should have read only access to the repository. | `list(string)` | `[]` | no |
| <a name="input_read_only_access_users"></a> [read\_only\_access\_users](#input\_read\_only\_access\_users) | AWS user ARNs that should have read only access to the repository. | `list(string)` | `[]` | no |
| <a name="input_scan_image_on_push"></a> [scan\_image\_on\_push](#input\_scan\_image\_on\_push) | Whether to trigger a scan for vulnerabilities when new images are pushed. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be set on all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_registry"></a> [registry](#output\_registry) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
