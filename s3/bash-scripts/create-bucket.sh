#!/bin/bash

# Check if a bucket name was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <bucket-name> [region]"
    exit 1
fi

BUCKET_NAME=$1
REGION=${2:-us-east-1}  # default region is us-east-1

echo "Creating S3 bucket: $BUCKET_NAME in region: $REGION"

# For us-east-1, the create-bucket command does not require --create-bucket-configuration
if [ "$REGION" = "us-east-1" ]; then
    aws s3api create-bucket \
        --bucket "$BUCKET_NAME" \
        --region "$REGION"
else
    aws s3api create-bucket \
        --bucket "$BUCKET_NAME" \
        --region "$REGION" \
        --create-bucket-configuration LocationConstraint="$REGION"
fi

# Check exit status
if [ $? -eq 0 ]; then
    echo "✅ Bucket '$BUCKET_NAME' created successfully."
else
    echo "❌ Failed to create bucket '$BUCKET_NAME'."
    exit 1
fi