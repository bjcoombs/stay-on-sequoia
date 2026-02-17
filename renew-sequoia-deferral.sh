#!/usr/bin/env bash
# Checks if the Stay on Sequoia deferral profile needs renewal
# and opens it for manual approval if within 7 days of expiry.

set -euo pipefail

PROFILE_ID="org.stayonsequoia.profile"
TEMPLATE="$HOME/Library/Scripts/deferral-90days.mobileconfig"
MAX_AGE_DAYS=83  # Renew when profile is older than 83 days (7-day buffer)

# Check if profile is installed and get install date
INSTALL_DATE=$(profiles show -type configuration 2>/dev/null \
  | grep -A20 "$PROFILE_ID" \
  | grep "installationDate" \
  | head -1 \
  | sed 's/.*: //' \
  | cut -d' ' -f1)

if [[ -z "$INSTALL_DATE" ]]; then
  NEEDS_RENEWAL=true
else
  INSTALL_EPOCH=$(date -j -f "%Y-%m-%d" "$INSTALL_DATE" "+%s" 2>/dev/null || echo "0")
  NOW_EPOCH=$(date "+%s")
  AGE_DAYS=$(( (NOW_EPOCH - INSTALL_EPOCH) / 86400 ))

  if [[ $AGE_DAYS -ge $MAX_AGE_DAYS ]]; then
    NEEDS_RENEWAL=true
  else
    NEEDS_RENEWAL=false
  fi
fi

if [[ "$NEEDS_RENEWAL" == "true" ]]; then
  UUID1=$(uuidgen)
  UUID2=$(uuidgen)
  TEMP_PROFILE=$(mktemp /tmp/sequoia-deferral-XXXXX.mobileconfig)
  sed -e "s/PAYLOAD-UUID/$UUID1/" -e "s/PROFILE-UUID/$UUID2/" "$TEMPLATE" > "$TEMP_PROFILE"

  open "$TEMP_PROFILE"
  sleep 2
  open "x-apple.systempreferences:com.apple.preferences.configurationprofiles"

  osascript -e 'display notification "Sequoia deferral profile needs renewal. Please click Install in System Settings." with title "Stay on Sequoia"'
fi
