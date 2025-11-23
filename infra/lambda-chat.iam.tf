data "aws_iam_policy_document" "warike_development_lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

## IAM Role for Lambda Chat
resource "aws_iam_role" "warike_development_lambda_chat_role" {
  name               = "lambda-role-chat-${local.project_name}"
  description        = "IAM role for Lambda Chat"
  assume_role_policy = data.aws_iam_policy_document.warike_development_lambda_assume_role.json
}

## Attach AWSLambdaBasicExecutionRole policy to role
resource "aws_iam_role_policy_attachment" "warike_development_lambda_chat_iam_policy_attachment" {
  role       = aws_iam_role.warike_development_lambda_chat_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

## Document for IAM policy to allow lambda to call S3 and Bedrock
data "aws_iam_policy_document" "warike_development_lambda_chat_policy_document" {
  version = "2012-10-17"

  # Bedrock access for chat model invocation
  statement {
    effect = "Allow"
    actions = [
      "bedrock:InvokeModel",
      "bedrock:InvokeModelWithResponseStream"
    ]
    resources = [
      "arn:aws:bedrock:*:*:foundation-model/*",
      "arn:aws:bedrock:*:*:inference-profile/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3vectors:QueryVectors",
      "s3vectors:GetVectors",
      "s3vectors:PutVectors",
      "s3vectors:DeleteVectors"
    ]
    resources = [
      var.vector_bucket_index_arn,
      "${var.vector_bucket_index_arn}/*"
    ]
  }
}

## IAM Policy for Lambda Chat
resource "aws_iam_policy" "warike_development_lambda_chat_policy" {
  name        = "${local.project_name}-lambda-chat-policy"
  description = "IAM Policy for Lambda Chat with S3 and Bedrock access"

  policy = data.aws_iam_policy_document.warike_development_lambda_chat_policy_document.json
}

## Attach IAM Policy to role
resource "aws_iam_role_policy_attachment" "warike_development_lambda_chat_policy_attachment" {
  role       = aws_iam_role.warike_development_lambda_chat_role.name
  policy_arn = aws_iam_policy.warike_development_lambda_chat_policy.arn
}
