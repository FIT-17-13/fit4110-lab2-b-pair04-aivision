#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://localhost:4010}"
AUTH_HEADER="Authorization: Bearer test-token"

echo "[Lab02] Testing Prism mock server at $BASE_URL"
echo

echo "[1/5] Happy path: GET /health"
curl -i "$BASE_URL/health"
echo "
---"

echo "[2/5] Happy path: GET /vision/results/recent"
curl -i "$BASE_URL/vision/results/recent" -H "$AUTH_HEADER"
echo "
---"

echo "[3/5] Happy path: POST /vision/face-match"
curl -i -X POST "$BASE_URL/vision/face-match" \
  -H "$AUTH_HEADER" \
  -H "Content-Type: application/json" \
  -d '{
    "requestType": "IMAGE_REF",
    "traceId": "0196fb3d-4ad7-7d1e-9f49-5d5148d2babc",
    "imageRef": "https://storage.campus.local/frames/frame-001.jpg"
  }'
echo "
---"

echo "[4/5] Happy path: GET /vision/detections/{detectionId}"
curl -i "$BASE_URL/vision/detections/0196fb3d-4ad7-7d1e-9f49-5d5148d2babc" -H "$AUTH_HEADER"
echo "
---"

echo "[5/5] Error case: POST /vision/face-match invalid payload"
curl -i -X POST "$BASE_URL/vision/face-match" \
  -H "$AUTH_HEADER" \
  -H "Content-Type: application/json" \
  -d '{ "requestType": "IMAGE_REF", "traceId": "not-a-uuid" }'
echo
