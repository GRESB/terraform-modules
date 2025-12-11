resource "aws_route53_record" "cognito_domain_alias_target_subdomain" {
  count = var.configure_custom_domain ? 1 : 0

  name    = var.configure_custom_domain
  type    = "A"
  zone_id = var.user_pool_custom_domain_route53_zone_id

  #checkov:skip=CKV2_AWS_23:The record points to a CloudFront distribution
  alias {
    evaluate_target_health = false
    name                   = join("", aws_cognito_user_pool_domain.custom_domain[*].cloudfront_distribution_arn)
    zone_id                = var.cloudfront_distribution_dnz_zone_id
  }
}


resource "aws_route53_record" "cognito_domain_alias_target_subdomain_ipv6" {
  count = var.configure_custom_domain ? 1 : 0

  name    = var.configure_custom_domain
  type    = "AAAA"
  zone_id = var.user_pool_custom_domain_route53_zone_id

  alias {
    evaluate_target_health = false
    name                   = join("", aws_cognito_user_pool_domain.custom_domain[*].cloudfront_distribution_arn)
    zone_id                = var.cloudfront_distribution_dnz_zone_id
  }
}
