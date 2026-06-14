$ErrorActionPreference = "Stop"

$BaseUrl = if ($env:BASE_URL) { $env:BASE_URL } else { "http://localhost:4010" }
$AuthHeader = "Authorization: Bearer test-token"

Write-Host "[Lab02] Testing Prism mock server at $BaseUrl"
Write-Host ""

Write-Host "[1/5] Happy path: GET /health"
curl.exe -i "$BaseUrl/health"
Write-Host "`n---"

Write-Host "[2/5] Happy path: GET /vision/results/recent"
curl.exe -i "$BaseUrl/vision/results/recent" -H $AuthHeader
Write-Host "`n---"

Write-Host "[3/5] Happy path: POST /vision/face-match"
$payload = '{
  "requestType": "IMAGE_REF",
  "traceId": "0196fb3d-4ad7-7d1e-9f49-5d5148d2babc",
  "imageRef": "https://storage.campus.local/frames/frame-001.jpg"
}'
curl.exe -i -X POST "$BaseUrl/vision/face-match" -H $AuthHeader -H "Content-Type: application/json" -d $payload
Write-Host "`n---"

Write-Host "[4/5] Happy path: GET /vision/detections/{detectionId}"
curl.exe -i "$BaseUrl/vision/detections/0196fb3d-4ad7-7d1e-9f49-5d5148d2babc" -H $AuthHeader
Write-Host "`n---"

Write-Host "[5/5] Error case: POST /vision/face-match invalid payload"
curl.exe -i -X POST "$BaseUrl/vision/face-match" -H $AuthHeader -H "Content-Type: application/json" -d '{ "requestType": "IMAGE_REF", "traceId": "not-a-uuid" }'
Write-Host ""
