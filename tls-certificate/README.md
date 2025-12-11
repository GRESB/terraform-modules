# aws-tls-certificate

Terraform module for requesting a ACM TLS certificate with route53 DNS validation

## Usage

This module requires two AWS providers to allow the creation of certificates in accounts that do not hold the route53 zone that manages the domain name.

The default provider creates the certificate (in the account it is connected to) and the `dns_zone` provider creates the DNS records for the validation.
If the certificate is to be created in the same account as the DNS zone just pass the same provider for both default and `dns_zone` alias.

To create certificates in different regions for the same domain names, validation can only be enabled for one of them, otherwise there will be a DNS record name clash.

### Create certificate in same account as DNZ zone
```hcl-terraform
module "tls_cert" {
  source = "git://gitlab.com/open-source-devex/terraform-modules/aws/tls-certificate.git?ref=v4.0.0"

  certificate_name = "my-tls-certificate"
  domain_name      = "example.com"
  subject_alternative_names = [
    "foo.example.com",
    "bar.example.com",
  ]

  tags = {
    project = "my-project"
  }

  providers = {
    aws           = aws
    aws.dnz_zone  = aws
  }
}
```

### Create certificate in one account while DNS zone is in a different account
```hcl-terraform
module "tls_cert" {
  source = "git::https://gitlab.com/open-source-devex/terraform-modules/aws/tls-certificate.git?ref=v4.0.0"

  certificate_name = "my-tls-certificate"
  domain_name      = "example.com"
  subject_alternative_names = [
    "foo.example.com",
    "bar.example.com",
  ]

  tags = {
    Name    = "my-tls-certificate"
    project = "my-project"
  }

  providers = {
    aws           = aws
    aws.dnz_zone  = aws.other_account
  }
}
```

### Create certificates using the same names in different regions
```hcl-terraform
module "tls_cert_eu_central_1" {
  source = "git::https://gitlab.com/open-source-devex/terraform-modules/aws/tls-certificate.git?ref=v4.0.0"

  certificate_name = "my-tls-certificate"
  domain_name      = "example.com"
  subject_alternative_names = [
    "foo.example.com",
    "bar.example.com",
  ]

  tags = {
    Name    = "my-tls-certificate"
    project = "my-project"
  }

  providers = {
    aws           = aws.eu_central_1
    aws.dnz_zone  = aws.other_account
  }
}

module "tls_cert_us_east_1" {
  source = "git::https://gitlab.com/open-source-devex/terraform-modules/aws/tls-certificate.git?ref=v4.0.0"

  certificate_name = "my-tls-certificate"
  domain_name      = "example.com"
  subject_alternative_names = [
    "foo.example.com",
    "bar.example.com",
  ]

  # validation DNS record would be the same as for module.tls_cert_eu_central_1,
  # so we disable it here to prevent duplicate record errors
  process_domain_validation_options = false

  tags = {
    Name    = "my-tls-certificate"
    project = "my-project"
  }

  providers = {
    aws           = aws.us_east_1
    aws.dnz_zone  = aws.other_account
  }
}
```

## Terraform docs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.63.0 |
| <a name="provider_aws.dns_zone"></a> [aws.dns\_zone](#provider\_aws.dns\_zone) | 3.63.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_name"></a> [certificate\_name](#input\_certificate\_name) | n/a | `string` | `"default-cert"` | no |
| <a name="input_dns_zone_domain_name"></a> [dns\_zone\_domain\_name](#input\_dns\_zone\_domain\_name) | The domain name of the DNS zone where validation records are created. If not supplied then domain\_name will be used to find the DNS zone. | `string` | `""` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | A domain name for which the certificate should be issued | `string` | n/a | yes |
| <a name="input_process_domain_validation_options"></a> [process\_domain\_validation\_options](#input\_process\_domain\_validation\_options) | Flag to enable/disable processing of the record to add to the DNS zone to complete certificate validation. Set to false to disable domain name validation. This is useful when another cert with the same name already exists which would create DNS record clash. This happens for instance when certificates are needed in different regions, but the DNS record is global. | `bool` | `true` | no |
| <a name="input_subject_alternative_names"></a> [subject\_alternative\_names](#input\_subject\_alternative\_names) | A list of domains that should be SANs in the issued certificate | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. map('BusinessUnit`,`XYZ`)` | `map(string)` | `{}` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | The TTL of the record to add to the DNS zone to complete certificate validation | `string` | `"300"` | no |
| <a name="input_validation_method"></a> [validation\_method](#input\_validation\_method) | Which method to use for validation, DNS or EMAIL | `string` | `"DNS"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the certificate |
| <a name="output_certificate_domain_name"></a> [certificate\_domain\_name](#output\_certificate\_domain\_name) | n/a |
| <a name="output_dns_zone_id"></a> [dns\_zone\_id](#output\_dns\_zone\_id) | The DNS Zone ID used to create the validation records for the certificate |
| <a name="output_domain_validation_options"></a> [domain\_validation\_options](#output\_domain\_validation\_options) | CNAME records that are added to the DNS zone to complete certificate validation |
| <a name="output_id"></a> [id](#output\_id) | The ARN of the certificate |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
