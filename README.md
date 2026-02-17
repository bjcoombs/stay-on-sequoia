# Stay on Sequoia

Block macOS Tahoe upgrade alerts with an auto-renewing deferral profile.

Defers the macOS Tahoe major upgrade by 90 days using a configuration profile. Minor Sequoia security patches are **not** deferred.

Auto-renews via LaunchAgent so you never have to think about it. When renewal is needed, it opens the profile in System Settings — you just click Install.

## Install

```bash
git clone https://github.com/bjcoombs/stay-on-sequoia.git
cd stay-on-sequoia
chmod +x install.sh
./install.sh
```

System Settings will open — click on the profile and hit **Install**.

Optionally add this alias to your `~/.zshrc`:

```bash
alias notahoe='~/Library/Scripts/renew-sequoia-deferral.sh'
```

## What it installs

| File | Purpose |
|------|---------|
| `~/Library/Scripts/renew-sequoia-deferral.sh` | Renewal script |
| `~/Library/Scripts/deferral-90days.mobileconfig` | Profile template |
| `~/Library/LaunchAgents/org.stayonsequoia.renew.plist` | Auto-renewal LaunchAgent |

## How it works

- LaunchAgent runs at login and daily at 10am
- Checks if the profile is older than 83 days (7-day safety buffer before the 90-day expiry)
- If renewal is needed: opens the profile + System Settings + sends a notification
- You click Install — done for another 83 days
- macOS requires manual approval for profiles (no way around this without MDM)

## Uninstall

```bash
chmod +x uninstall.sh
./uninstall.sh
```

Then remove the profile manually: **System Settings → General → Device Management → Remove**

## Manual renewal

Run anytime:

```bash
notahoe
# or: ~/Library/Scripts/renew-sequoia-deferral.sh
```

## Credit

- [robservatory.com](https://robservatory.com/block-the-upgrade-to-tahoe-alerts-and-system-settings-indicator/)
- [travisvn/stop-tahoe-update](https://github.com/travisvn/stop-tahoe-update)
