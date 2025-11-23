#!/bin/bash
# URL obtained from terraform output
URL="https://dev.zaistev.com/"
PAYLOAD='{"prompt": "Tell about AWS AppSync"}'

# Calculate SHA256 hash of the payload for CloudFront POST requests
# This is required because Lambda doesn't support unsigned payloads when accessed via CloudFront with PUT/POST
PAYLOAD_HASH=$(echo -n "$PAYLOAD" | shasum -a 256 | awk '{print $1}')

echo "----------------------------------------------------------------"
echo "Testing Lambda Stream (GET)"
echo "URL: $URL"
echo "----------------------------------------------------------------"

# -N disables buffering to see the stream in real-time
curl -N "$URL"

echo ""
echo "----------------------------------------------------------------"
echo "Testing Lambda Stream (POST)"
echo "URL: $URL"
echo "Payload Hash: $PAYLOAD_HASH"
echo "----------------------------------------------------------------"

# -N disables buffering to see the stream in real-time
curl -N -X POST \
  -H "Content-Type: application/json" \
  -H "x-amz-content-sha256: $PAYLOAD_HASH" \
  -d "$PAYLOAD" \
  "$URL"

echo ""
echo "----------------------------------------------------------------"
