locals {
  dns_zone_domain_name = var.dns_zone_domain_name != "" ? var.dns_zone_domain_name : var.domain_name

  validation_dns_zone_id = split(",", local.create_dns_validation_records ? join(",", data.aws_route53_zone.default[*].zone_id) : "")
}

resource "aws_acm_certificate" "default" {
  domain_name               = var.domain_name
  validation_method         = var.validation_method
  subject_alternative_names = var.subject_alternative_names

  tags = merge(var.tags,
    {
      Name = var.certificate_name
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

provider "aws" {
  alias = "dns_zone"
}
