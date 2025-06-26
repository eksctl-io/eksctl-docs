#!/bin/bash

# Configuration variables
BUCKET_NAME="gcline-aws-docs-search"
ZIP_FILE_PATH="build/html-zip/AmazonEksEksctlDocs.zip"
AWS_PROFILE="gcline-Admin"
AWS_REGION="us-east-1"


# Upload ZIP file to S3
echo "Uploading ZIP file to S3..."
aws s3 cp "$ZIP_FILE_PATH" "s3://$BUCKET_NAME/zips/" --profile "$AWS_PROFILE"

if [ $? -ne 0 ]; then
    echo "Failed to upload ZIP file to S3"
    exit 1
fi

# Get the filename without path
ZIP_FILENAME=$(basename "$ZIP_FILE_PATH")




# Create event payload for Lambda
EVENT_PAYLOAD=$(cat <<EOF
{
  "bucketName": "$BUCKET_NAME",
  "sourceKey": "zips/$ZIP_FILENAME"
}
EOF
)

# Invoke Lambda function and capture request ID
echo "Invoking Lambda function..."
RESPONSE=$(aws lambda invoke \
    --region "us-east-1" \
    --profile "$AWS_PROFILE" \
    --function-name "gcline-aws-docs-index" \
    --payload "$EVENT_PAYLOAD" \
    /dev/stdout)

REQUEST_ID=$(echo $RESPONSE | jq -r '.ResponseMetadata.RequestId')

if [ -z "$REQUEST_ID" ]; then
    echo "Failed to invoke Lambda function"
    exit 1
fi

echo "Lambda invoked successfully."

