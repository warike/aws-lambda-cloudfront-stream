## Amazon Certificate Manager
module "warike_development_acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 6.1.0"

  domain_name               = local.domain_name
  zone_id                   = data.aws_route53_zone.warike_development_warike_tech.id
  subject_alternative_names = ["*.${local.domain_name}", "${local.domain_name}"]

  validation_method = "DNS"

  tags = local.tags
}

## Route 53 - Hosted Zone
data "aws_route53_zone" "warike_development_warike_tech" {
  name = local.domain_name
}

## Route 53 - Apex Record
resource "aws_route53_record" "warike_development_apex_record" {
  zone_id = data.aws_route53_zone.warike_development_warike_tech.zone_id
  name    = local.domain_name
  type    = "A"

  alias {
    name                   = module.warike_development_cloudfront.cloudfront_distribution_domain_name
    zone_id                = module.warike_development_cloudfront.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [
    module.warike_development_cloudfront,
  ]
}
