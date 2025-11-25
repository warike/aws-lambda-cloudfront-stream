#!/bin/bash

# Script to create S3 Vector Store bucket and index
# This script creates the necessary infrastructure for vector storage and retrieval

set -e  # Exit on error

# Configuration
VECTOR_BUCKET_NAME="${VECTOR_BUCKET_NAME:-bucket-vector-s3-lambda}"
INDEX_NAME="${INDEX_NAME:-documents}"
DATA_TYPE="${DATA_TYPE:-float32}"
DIMENSION="${DIMENSION:-1024}"
DISTANCE_METRIC="${DISTANCE_METRIC:-cosine}"
REGION="${AWS_REGION:-us-east-1}"
PROFILE="${AWS_PROFILE:-warike-development}"

echo "=========================================="
echo "S3 Vector Store Setup"
echo "=========================================="
echo "Bucket Name: $VECTOR_BUCKET_NAME"
echo "Index Name: $INDEX_NAME"
echo "Region: $REGION"
echo "Profile: $PROFILE"
echo "=========================================="
echo ""

# Step 1: Create Vector Bucket
echo "Step 1/2: Creating S3 Vector Bucket..."
if aws s3vectors create-vector-bucket \
    --vector-bucket-name "$VECTOR_BUCKET_NAME" \
    --region "$REGION" \
    --profile "$PROFILE" 2>&1; then
    echo "✓ Vector bucket created successfully"
else
    # Check if bucket already exists
    if aws s3vectors list-vector-buckets \
        --region "$REGION" \
        --profile "$PROFILE" 2>&1 | grep -q "$VECTOR_BUCKET_NAME"; then
        echo "⚠ Vector bucket already exists, continuing..."
    else
        echo "✗ Failed to create vector bucket"
        exit 1
    fi
fi

echo ""

# Step 2: Create Index
echo "Step 2/2: Creating Vector Index..."
if aws s3vectors create-index \
    --vector-bucket-name "$VECTOR_BUCKET_NAME" \
    --index-name "$INDEX_NAME" \
    --data-type "$DATA_TYPE" \
    --dimension "$DIMENSION" \
    --distance-metric "$DISTANCE_METRIC" \
    --metadata-configuration nonFilterableMetadataKeys=id,chunk \
    --region "$REGION" \
    --profile "$PROFILE" 2>&1; then
    echo "✓ Vector index created successfully"
else
    # Check if index already exists
    ERROR_MSG=$(aws s3vectors create-index \
        --vector-bucket-name "$VECTOR_BUCKET_NAME" \
        --index-name "$INDEX_NAME" \
        --data-type "$DATA_TYPE" \
        --dimension "$DIMENSION" \
        --distance-metric "$DISTANCE_METRIC" \
        --metadata-configuration nonFilterableMetadataKeys=id,chunk \
        --region "$REGION" \
        --profile "$PROFILE" 2>&1 || true)
    
    if echo "$ERROR_MSG" | grep -q "already exists"; then
        echo "⚠ Vector index already exists, continuing..."
    else
        echo "✗ Failed to create vector index"
        echo "$ERROR_MSG"
        exit 1
    fi
fi

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Vector Bucket ARN:"
aws s3vectors list-vector-buckets \
    --region "$REGION" \
    --profile "$PROFILE" \
    --query "VectorBuckets[?VectorBucketName=='$VECTOR_BUCKET_NAME'].VectorBucketArn" \
    --output text 2>/dev/null || echo "Unable to retrieve ARN"

echo ""
echo "Index ARN:"
aws s3vectors list-indexes \
    --vector-bucket-name "$VECTOR_BUCKET_NAME" \
    --region "$REGION" \
    --profile "$PROFILE" \
    --query "Indexes[?IndexName=='$INDEX_NAME'].IndexArn" \
    --output text 2>/dev/null || echo "Unable to retrieve ARN"

echo ""
echo "Add the Index ARN to your terraform.tfvars file:"
echo "vector_bucket_index_arn = \"<INDEX_ARN_FROM_ABOVE>\""
