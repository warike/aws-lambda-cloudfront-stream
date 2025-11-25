locals {
  lambda_chat = {
    name        = "chat-${basename(path.cwd)}"
    image       = "${aws_ecr_repository.warike_development_ecr.repository_url}:chat-latest"
    description = "Lambda chat function for ${local.project_name}"
    memory_size = 512
    timeout     = 60
    env_vars = {
      AWS_BEARER_TOKEN_BEDROCK    = var.aws_bearer_token_bedrock
      AWS_BEDROCK_MODEL           = var.aws_bedrock_model
      NODE_OPTIONS                = "--enable-source-maps --stack-trace-limit=1000"
      AWS_VECTOR_BUCKET_INDEX_ARN = var.vector_bucket_index_arn
      AWS_BEDROCK_MODEL_EMBEDDING = var.aws_bedrock_model_embedding
    }
  }
}

## Lambda Chat
module "warike_development_lambda_chat" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 8.1.2"

  ## Configuration
  function_name = local.lambda_chat.name
  description   = local.lambda_chat.description
  memory_size   = local.lambda_chat.memory_size
  timeout       = local.lambda_chat.timeout

  ## Package
  create_package = false
  package_type   = "Image"
  image_uri      = local.lambda_chat.image
  environment_variables = merge(
    local.lambda_chat.env_vars,
    {}
  )

  ## API Gateway
  create_current_version_allowed_triggers = false

  ## Permissions
  create_role = false
  lambda_role = aws_iam_role.warike_development_lambda_chat_role.arn

  ## Logging
  use_existing_cloudwatch_log_group = true
  logging_log_group                 = aws_cloudwatch_log_group.warike_development_lambda_chat_logs.name
  logging_log_format                = "JSON"
  logging_application_log_level     = "INFO"
  logging_system_log_level          = "WARN"

  ## Response Streaming
  invoke_mode = "RESPONSE_STREAM"

  ## Lambda Function URL for testing
  create_lambda_function_url = true
  authorization_type         = "AWS_IAM"

  cors = {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["*"]
    expose_headers    = ["*"]
    max_age           = 86400
  }

  tags = merge(local.tags, { Name = local.lambda_chat.name })

  depends_on = [
    aws_cloudwatch_log_group.warike_development_lambda_chat_logs,
    aws_ecr_repository.warike_development_ecr,
    null_resource.warike_development_build_image_seed
  ]
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = module.warike_development_lambda_chat.lambda_function_name
}

output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = module.warike_development_lambda_chat.lambda_function_arn
}

output "lambda_function_url" {
  description = "Lambda function URL (for direct testing)"
  value       = module.warike_development_lambda_chat.lambda_function_url
}
