#!/bin/bash
set -e

# Get the absolute path to the script's directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the infra directory to run terraform commands
cd "$SCRIPT_DIR"

# Get configuration from Terraform
echo "📋 Retrieving configuration from Terraform..."

# Get AWS region from terraform variables
AWS_REGION=$(terraform output -raw aws_region 2>/dev/null || echo "us-east-1")

# Get AWS profile from terraform variables
AWS_PROFILE=$(terraform output -raw aws_profile 2>/dev/null || echo "default")

# Get AWS account ID from terraform data source
ACCOUNT_ID=$(terraform output -raw account_id 2>/dev/null || aws sts get-caller-identity --profile "$AWS_PROFILE" --query Account --output text)

# Get ECR repository name from terraform
ECR_REPO_NAME=$(terraform output -raw ecr_repository_name 2>/dev/null)

# Get image tag from argument or extract from lambda-chat.tf
IMAGE_TAG=${1:-$(grep -oP 'image\s*=\s*"\${aws_ecr_repository\.warike_development_ecr\.repository_url}:\K[^"]+' lambda-chat.tf || echo "chat-latest")}

# Construct URIs
ECR_URI="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
FULL_IMAGE_URI="${ECR_URI}/${ECR_REPO_NAME}:${IMAGE_TAG}"

# Define source directory relative to the script location
SOURCE_DIR="${SCRIPT_DIR}/../apps/server"

echo "----------------------------------------------------------------"
echo "Deploying Chat Lambda Image"
echo "Region: $AWS_REGION"
echo "Image: $FULL_IMAGE_URI"
echo "Source: $SOURCE_DIR"
echo "----------------------------------------------------------------"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory $SOURCE_DIR does not exist."
    exit 1
fi

echo "1. Logging in to Amazon ECR..."
aws ecr get-login-password --region $AWS_REGION --profile $AWS_PROFILE | docker login --username AWS --password-stdin $ECR_URI

echo "2. Building Docker image..."
# Using --platform linux/amd64 is crucial for Lambda if building on Apple Silicon
# --provenance=false is needed to avoid "image manifest ... not supported" errors in Lambda
docker build --platform linux/amd64 --provenance=false -t $FULL_IMAGE_URI "$SOURCE_DIR"

echo "3. Pushing image to ECR..."
docker push $FULL_IMAGE_URI

echo "----------------------------------------------------------------"
echo "Success! Image uploaded to:"
echo "$FULL_IMAGE_URI"
echo "----------------------------------------------------------------"
