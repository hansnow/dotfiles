# Han macOS Preferences

## Scripted

Every run first creates a timestamped backup directory under `~/.han-macos-defaults-backups/` unless `HAN_MACOS_BACKUP_ROOT` is set. The directory name also includes the script process ID to avoid collisions. The backup contains exported snapshots of the affected defaults domains and a generated `restore.sh` script.

Restore example:

```bash
~/.han-macos-defaults-backups/YYYYMMDD-HHMMSS-PID/restore.sh
```

The restore script imports full snapshots for the affected domains: global defaults, current-host global defaults, Apple multitouch trackpad/mouse domains, Dock, and Finder. Use it soon after a bad setup run; it may also revert unrelated preference changes made in those same domains after the backup was created.

- Keyboard repeat: `InitialKeyRepeat=15`, `KeyRepeat=2`.
- Modifier mapping: Caps Lock source `0x700000039` maps to Right Control destination `0x7000000E4`.
- Trackpad: tap to click, secondary click, three-finger drag, natural scrolling, smart zoom, Mission Control/app expose gestures, momentum scrolling, pinch/rotate enabled, force click disabled.
- Trackpad speed: `com.apple.trackpad.scaling=1`.
- Magic Mouse: one-button mode, horizontal/vertical/momentum scroll enabled, one-finger double tap disabled, two-finger double tap set to Mission Control, two-finger horizontal swipe enabled.
- Dock: autohide enabled.
- Finder: new windows open `~/Downloads`.

## Known App Domains

These domains exist on the source machine but should not be imported wholesale:

- `com.runningwithcrayons.Alfred`
- `com.runningwithcrayons.Alfred-Preferences`
- `com.bjango.istatmenus*`
- `com.knollsoft.Rectangle`
- `im.rime.inputmethod.Squirrel`
- `com.mitchellh.ghostty`
- `io.github.clash-verge-rev.clash-verge-rev`

Use each app's supported sync/export feature when possible. If migrating with `defaults`, copy only explicit stable keys, not caches, timestamps, window frames, device identifiers, or license/session/account data.

Menu bar spacing is managed by Bartender on the source machine. Do not write `NSStatusItemSpacing` or `NSStatusItemSelectionPadding` directly unless the user explicitly chooses to replace Bartender behavior with system defaults.

## Not Scripted By Default

- Input sources currently include ABC, Apple Simplified Chinese Shuangpin, and Squirrel/Rime history. Do not overwrite input source lists unless the user asks.
- No standalone `com.apple.mouse.scaling` value was found on the source machine.
- Screenshot settings on the source machine mostly reflected recent selection state, not a durable preference.
- Dock pinned apps were customized by removing some default persistent apps, but the desired final pinned-app list is not yet encoded. Do not clear or rewrite `persistent-apps` until the user confirms the exact Dock layout.
- Third-party app configuration, including Rectangle, Bartender, Alfred, iStat Menus, Squirrel/Rime, and Ghostty, is intentionally deferred for a separate pass.
