## Lambda Cloudwatch log group
resource "aws_cloudwatch_log_group" "warike_development_lambda_chat_logs" {
  name              = "/aws/lambda/${local.lambda_chat.name}"
  retention_in_days = 7
}

## IAM role policy for Cloudwatch logging
data "aws_iam_policy_document" "warike_development_lambda_chat_logging" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/${local.lambda_chat.name}:*",
    ]
  }
}

## Cloudwatch Lambda logs IAM policy
resource "aws_iam_role_policy" "warike_development_lambda_chat_grouplogs" {
  name = "cloudwatch-${local.lambda_chat.name}-${local.project_name}"
  role = aws_iam_role.warike_development_lambda_chat_role.id

  policy = data.aws_iam_policy_document.warike_development_lambda_chat_logging.json
}
