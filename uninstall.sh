#!/usr/bin/env bash
# Stay on Sequoia - Uninstaller
# Removes the LaunchAgent and scripts. Profile must be removed manually.

set -euo pipefail

echo "=== Stay on Sequoia Uninstaller ==="
echo ""

# 1. Unload and remove LaunchAgent
PLIST="$HOME/Library/LaunchAgents/org.stayonsequoia.renew.plist"
if [[ -f "$PLIST" ]]; then
  launchctl unload "$PLIST" 2>/dev/null || true
  rm "$PLIST"
  echo "Removed LaunchAgent."
else
  echo "LaunchAgent not found (already removed)."
fi

# 2. Remove scripts
rm -f "$HOME/Library/Scripts/renew-sequoia-deferral.sh"
rm -f "$HOME/Library/Scripts/deferral-90days.mobileconfig"
echo "Removed scripts."

echo ""
echo "Done. To also remove the installed profile:"
echo "  System Settings -> General -> Device Management"
echo "  -> 'Stay on Sequoia: Update Deferrals' -> Remove"
