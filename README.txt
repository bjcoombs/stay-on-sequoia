Stay on Sequoia - Block Tahoe Upgrade
======================================

Defers macOS Tahoe major upgrade by 90 days using a configuration
profile. Minor Sequoia security patches are NOT deferred.

Auto-renews via LaunchAgent so you never have to think about it.
When renewal is needed, it opens the profile in System Settings -
you just click Install.


INSTALL
-------
1. Unzip this folder
2. Open Terminal
3. Run:

   cd ~/Downloads/stay-on-sequoia-kit
   chmod +x install.sh
   ./install.sh

4. System Settings will open - click on the profile and hit Install
5. Optionally add this alias to your ~/.zshrc:

   alias notahoe='~/Library/Scripts/renew-sequoia-deferral.sh'


WHAT IT INSTALLS
----------------
- ~/Library/Scripts/renew-sequoia-deferral.sh    (renewal script)
- ~/Library/Scripts/deferral-90days.mobileconfig  (profile template)
- ~/Library/LaunchAgents/org.stayonsequoia.renew.plist (auto-renewal)


HOW IT WORKS
------------
- LaunchAgent runs at login and daily at 10am
- Checks if the profile is older than 83 days (7-day safety buffer)
- If renewal needed: opens the profile + System Settings + notification
- You click Install - done for another 83 days
- macOS requires manual approval for profiles (no way around this)


UNINSTALL
---------
   chmod +x uninstall.sh
   ./uninstall.sh

Then remove the profile manually:
   System Settings -> General -> Device Management -> Remove


MANUAL RENEWAL
--------------
Run anytime:  notahoe
(or: ~/Library/Scripts/renew-sequoia-deferral.sh)


CREDIT
------
Based on: https://robservatory.com/block-the-upgrade-to-tahoe-alerts-and-system-settings-indicator/
Uses: https://github.com/travisvn/stop-tahoe-update
