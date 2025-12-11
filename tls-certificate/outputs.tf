output "id" {
  value       = aws_acm_certificate.default.id
  description = "The ARN of the certificate"
}

output "arn" {
  value       = aws_acm_certificate.default.arn
  description = "The ARN of the certificate"
}

output "certificate_domain_name" {
  value = aws_acm_certificate.default.domain_name
}

output "domain_validation_options" {
  value       = aws_acm_certificate.default.domain_validation_options
  description = "CNAME records that are added to the DNS zone to complete certificate validation"
}

output "dns_zone_id" {
  value       = length(local.validation_dns_zone_id) > 0 ? element(local.validation_dns_zone_id, 0) : "VALIDATION DISABLED"
  description = "The DNS Zone ID used to create the validation records for the certificate"
}
