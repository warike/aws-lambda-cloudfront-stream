data "aws_caller_identity" "current" {}

## ECR Repository
resource "aws_ecr_repository" "warike_development_ecr" {
  name                 = "ecr-${local.project_name}"
  image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability_exclusion_filter {
    filter      = "*latest"
    filter_type = "WILDCARD"
  }

  force_delete = true
}

## ECR Lifecycle policy
resource "aws_ecr_lifecycle_policy" "warike_development_ecr_lifecycle_policy" {
  repository = aws_ecr_repository.warike_development_ecr.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 7 tagged images for rollback window"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v", "release", "prod"]
          countType     = "imageCountMoreThan"
          countNumber   = 7
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Delete untagged images older than 7 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 3
        description  = "Delete any tagged images older than 30 days (safety net)"
        selection = {
          tagStatus   = "any"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "null_resource" "warike_development_build_image_seed" {
  provisioner "local-exec" {
    command = "/bin/bash ${path.module}/push_chat_image.sh"
  }

  depends_on = [aws_ecr_repository.warike_development_ecr]
}

## Outputs for push_chat_image.sh script
output "ecr_repository_name" {
  description = "ECR repository name"
  value       = aws_ecr_repository.warike_development_ecr.name
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.warike_development_ecr.repository_url
}

output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS Region"
  value       = var.aws_region
}

output "aws_profile" {
  description = "AWS Profile"
  value       = var.aws_profile
}
