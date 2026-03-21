#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID="${GOOGLE_CLOUD_PROJECT:-${GCP_PROJECT_ID:-}}"
CONFIG_FILE="${FIREBASE_CONFIG_FILE:-firebase.hosting.json}"
HOSTING_SITE="${FIREBASE_HOSTING_SITE:-}"

if [[ -z "$PROJECT_ID" ]]; then
  echo "GOOGLE_CLOUD_PROJECT or GCP_PROJECT_ID is required." >&2
  exit 1
fi

if [[ -n "$HOSTING_SITE" ]]; then
  CONFIG_FILE="$(mktemp)"
  cat > "$CONFIG_FILE" <<EOF
{
  "hosting": {
    "site": "$HOSTING_SITE",
    "public": "dist",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ]
  }
}
EOF
fi

npx firebase-tools deploy \
  --project "$PROJECT_ID" \
  --config "$CONFIG_FILE" \
  --only hosting
