# ── DNS: dev.hossainpazooki.com ──────────────────────────────

variable "domain_name" {
  description = "Root domain name"
  type        = string
  default     = "hossainpazooki.com"
}

data "aws_route53_zone" "main" {
  name = var.domain_name
}

data "aws_acm_certificate" "wildcard" {
  domain      = "*.${var.domain_name}"
  statuses    = ["ISSUED"]
  most_recent = true
}

# Look up ALB created by AWS LB Controller (by ingress group tags)
data "aws_lb" "dev_ingress" {
  tags = {
    "elbv2.k8s.aws/cluster" = "institutional-defi-eks"
    "ingress.k8s.aws/stack" = "institutional-defi-dev"
  }
}

resource "aws_route53_record" "dev" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "dev.${var.domain_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.dev_ingress.dns_name
    zone_id                = data.aws_lb.dev_ingress.zone_id
    evaluate_target_health = true
  }
}

output "dev_domain" {
  value = "https://${aws_route53_record.dev.name}"
}

output "acm_certificate_arn" {
  value = data.aws_acm_certificate.wildcard.arn
}
