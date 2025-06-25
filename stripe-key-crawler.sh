#!/bin/bash

# === stripe-key-crawler.sh ===
# Educational tool to find leaked Stripe API keys in files
# Usage: ./stripe-key-crawler.sh /path/to/your/project

TARGET_DIR=${1:-.}

echo "🔍 Scanning directory: $TARGET_DIR"
echo "======================================="
echo

MATCH_COUNT=0

# Find files (excluding binaries)
find "$TARGET_DIR" -type f \( -name "*.js" -o -name "*.env" -o -name "*.php" -o -name "*.html" -o -name "*.py" -o -name "*.json" -o -name "*.txt" -o -name "*.md" \) | while read -r FILE; do
  MATCHES=$(grep -Eo "sk_live_[0-9a-zA-Z]{24,}" "$FILE")
  if [ ! -z "$MATCHES" ]; then
    echo "🚨 Potential Stripe Key found in: $FILE"
    grep -En "sk_live_[0-9a-zA-Z]{24,}" "$FILE" | sed 's/^/    🔹 /'
    echo
    ((MATCH_COUNT++))
  fi
done

echo "======================================="
echo "🧮 Total files with possible Stripe keys: $MATCH_COUNT"
