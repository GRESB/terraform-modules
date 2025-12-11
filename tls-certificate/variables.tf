variable "certificate_name" {
  type    = string
  default = "default-cert"
}

variable "domain_name" {
  type        = string
  description = "A domain name for which the certificate should be issued"
}

variable "subject_alternative_names" {
  type        = list(string)
  default     = []
  description = "A list of domains that should be SANs in the issued certificate"
}

variable "validation_method" {
  type        = string
  default     = "DNS"
  description = "Which method to use for validation, DNS or EMAIL"
}

variable "dns_zone_domain_name" {
  type        = string
  default     = ""
  description = "The domain name of the DNS zone where validation records are created. If not supplied then domain_name will be used to find the DNS zone."
}

variable "process_domain_validation_options" {
  type        = bool
  default     = true
  description = "Flag to enable/disable processing of the record to add to the DNS zone to complete certificate validation. Set to false to disable domain name validation. This is useful when another cert with the same name already exists which would create DNS record clash. This happens for instance when certificates are needed in different regions, but the DNS record is global."
}

variable "ttl" {
  type        = string
  default     = "300"
  description = "The TTL of the record to add to the DNS zone to complete certificate validation"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map('BusinessUnit`,`XYZ`)"
}
