variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "my_project"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "aws_profile" {
  description = "AWS profile name"
  type        = string
  default     = "default"
}

variable "aws_bearer_token_bedrock" {
  description = "AWS Bearer Token for Bedrock"
  type        = string
}

variable "aws_bedrock_model" {
  description = "AWS Bedrock Model"
  type        = string
}

variable "vector_bucket_index_arn" {
  description = "Vector bucket index ARN"
  type        = string
}

variable "aws_bedrock_model_embedding" {
  description = "AWS Bedrock Model for Embedding"
  type        = string
}
