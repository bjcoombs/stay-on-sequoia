#!/usr/bin/env bash
# Stay on Sequoia - One-shot installer
# Installs the deferral profile, renewal script, and LaunchAgent.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Stay on Sequoia Installer ==="
echo ""

# 1. Copy files to permanent locations
echo "1. Installing renewal script and profile template..."
mkdir -p "$HOME/Library/Scripts"
cp "$SCRIPT_DIR/renew-sequoia-deferral.sh" "$HOME/Library/Scripts/"
cp "$SCRIPT_DIR/deferral-90days.mobileconfig" "$HOME/Library/Scripts/"
chmod 755 "$HOME/Library/Scripts/renew-sequoia-deferral.sh"

# 2. Install LaunchAgent (replace __HOME__ with actual home dir)
echo "2. Installing LaunchAgent (runs at login + daily at 10am)..."
mkdir -p "$HOME/Library/LaunchAgents"
sed "s|__HOME__|$HOME|g" "$SCRIPT_DIR/org.stayonsequoia.renew.plist" \
  > "$HOME/Library/LaunchAgents/org.stayonsequoia.renew.plist"

# 3. Load LaunchAgent
launchctl load "$HOME/Library/LaunchAgents/org.stayonsequoia.renew.plist" 2>/dev/null || true

# 4. Install the profile now
echo "3. Generating and opening deferral profile..."
UUID1=$(uuidgen)
UUID2=$(uuidgen)
TEMP_PROFILE=$(mktemp /tmp/sequoia-deferral-XXXXX.mobileconfig)
sed -e "s/PAYLOAD-UUID/$UUID1/" -e "s/PROFILE-UUID/$UUID2/" \
  "$HOME/Library/Scripts/deferral-90days.mobileconfig" > "$TEMP_PROFILE"

open "$TEMP_PROFILE"
sleep 2
open "x-apple.systempreferences:com.apple.preferences.configurationprofiles"

echo ""
echo "=== Almost done! ==="
echo ""
echo "System Settings should now be open to Profiles."
echo "Click on 'Stay on Sequoia: Update Deferrals' and hit Install."
echo ""
echo "After that, you're all set. The profile will auto-renew"
echo "every 83 days (7-day buffer before the 90-day expiry)."
echo ""
echo "Manual renewal anytime:  notahoe"
echo "  (add this alias to your .zshrc):"
echo "  alias notahoe='~/Library/Scripts/renew-sequoia-deferral.sh'"
