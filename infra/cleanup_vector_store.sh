#!/bin/bash

# Script to delete S3 Vector Store bucket and index
# WARNING: This will permanently delete all vector data

set -e  # Exit on error

# Configuration
VECTOR_BUCKET_NAME="${VECTOR_BUCKET_NAME:-bucket-vector-s3-lambda}"
INDEX_NAME="${INDEX_NAME:-documents}"
REGION="${AWS_REGION:-us-east-1}"
PROFILE="${AWS_PROFILE:-warike-development}"

echo "=========================================="
echo "S3 Vector Store Cleanup"
echo "=========================================="
echo "Bucket Name: $VECTOR_BUCKET_NAME"
echo "Index Name: $INDEX_NAME"
echo "Region: $REGION"
echo "Profile: $PROFILE"
echo "=========================================="
echo ""
echo "⚠️  WARNING: This will permanently delete all vector data!"
echo ""

# Confirmation prompt
read -p "Are you sure you want to continue? (yes/no): " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo ""

# Step 1: Delete Index
echo "Step 1/2: Deleting Vector Index..."
if aws s3vectors delete-index \
    --vector-bucket-name "$VECTOR_BUCKET_NAME" \
    --index-name "$INDEX_NAME" \
    --region "$REGION" \
    --profile "$PROFILE" 2>&1; then
    echo "✓ Vector index deleted successfully"
else
    ERROR_MSG=$(aws s3vectors delete-index \
        --vector-bucket-name "$VECTOR_BUCKET_NAME" \
        --index-name "$INDEX_NAME" \
        --region "$REGION" \
        --profile "$PROFILE" 2>&1 || true)
    
    if echo "$ERROR_MSG" | grep -q "not found\|does not exist"; then
        echo "⚠ Vector index does not exist, continuing..."
    else
        echo "✗ Failed to delete vector index"
        echo "$ERROR_MSG"
        exit 1
    fi
fi

echo ""

# Step 2: Delete Vector Bucket
echo "Step 2/2: Deleting S3 Vector Bucket..."
if aws s3vectors delete-vector-bucket \
    --vector-bucket-name "$VECTOR_BUCKET_NAME" \
    --region "$REGION" \
    --profile "$PROFILE" 2>&1; then
    echo "✓ Vector bucket deleted successfully"
else
    ERROR_MSG=$(aws s3vectors delete-vector-bucket \
        --vector-bucket-name "$VECTOR_BUCKET_NAME" \
        --region "$REGION" \
        --profile "$PROFILE" 2>&1 || true)
    
    if echo "$ERROR_MSG" | grep -q "not found\|does not exist"; then
        echo "⚠ Vector bucket does not exist, continuing..."
    else
        echo "✗ Failed to delete vector bucket"
        echo "$ERROR_MSG"
        exit 1
    fi
fi

echo ""
echo "=========================================="
echo "Cleanup Complete!"
echo "=========================================="
echo ""
echo "All vector data has been deleted."
echo "Run ./setup_vector_store.sh to recreate the infrastructure."
