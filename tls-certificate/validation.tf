locals {
  create_dns_validation_records = var.process_domain_validation_options && var.validation_method == "DNS"
}

resource "aws_route53_record" "validation" {
  for_each = local.create_dns_validation_records ? {
    for dvo in aws_acm_certificate.default.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    } if dvo.domain_name != "*.${var.domain_name}" # wildcard names produce duplicate DNS validation records
  } : {}

  ttl = var.ttl

  name = each.value.name
  type = each.value.type

  records = [each.value.record]

  zone_id = data.aws_route53_zone.default[0].zone_id

  provider = aws.dns_zone
}

resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.default.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

data "aws_route53_zone" "default" {
  count = local.create_dns_validation_records ? 1 : 0

  name         = "${local.dns_zone_domain_name}."
  private_zone = false

  provider = aws.dns_zone
}
