#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

PROJECT_ID="${GOOGLE_CLOUD_PROJECT:-${GCP_PROJECT_ID:-}}"
CONFIG_FILE="${FIREBASE_CONFIG_FILE:-$REPO_ROOT/firebase.hosting.json}"
HOSTING_SITE="${FIREBASE_HOSTING_SITE:-}"
PUBLIC_DIR="$REPO_ROOT/dist"

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
    "public": "$PUBLIC_DIR",
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
