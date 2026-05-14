---
name: setup-han-macos
description: Set up a new macOS machine using Han's personal defaults and dotfiles habits. Use when asked to configure a new Mac, migrate Han's macOS preferences, apply keyboard/mouse/trackpad/Dock/Finder defaults, run this dotfiles Brewfile, or avoid manually changing macOS Settings one by one.
---

# Setup Han macOS

## Workflow

1. Locate the dotfiles checkout. If the current directory contains `Brewfile`, use that directory as the setup root.
2. Install command-line and GUI apps with Homebrew when requested or when setting up a fresh machine:
   ```bash
   brew bundle --file Brewfile
   ```
3. Apply macOS system defaults with:
   ```bash
   bash setup-han-macos/scripts/apply-macos-defaults.sh
   ```
   If the skill is installed outside the dotfiles repo, run the script from the skill directory instead:
   ```bash
   bash scripts/apply-macos-defaults.sh
   ```
4. Confirm the backup path printed by the script. Each run creates a timestamped backup under `~/.han-macos-defaults-backups/` by default and includes a `restore.sh` script.
5. Tell the user that some keyboard, trackpad, and permission-protected settings may require logout or reboot.
6. Do not configure third-party apps yet. For app-specific settings, read `references/current-preferences.md` first and wait for the user to explicitly add that app to the setup profile.

## Safety Rules

- Prefer the bundled script over rewriting `defaults write` commands.
- Do not migrate window positions, recent files, analytics timestamps, cache keys, device UUIDs, or account/session state.
- Do not overwrite input method lists unless the user explicitly asks. They vary by macOS version and installed input methods.
- Do not rewrite Dock pinned apps until the user confirms the exact desired Dock layout.
- Do not write menu bar spacing keys directly. The source machine uses Bartender for that behavior.
- If Homebrew is missing, ask before installing it because it runs a network installer.
- If the target Mac has different hardware, still apply the keyboard/Dock/Finder settings, but mention that trackpad and Magic Mouse settings only matter when those devices exist.
- Keep the backup step before any `defaults write` or `hidutil property --set`. The restore script imports full snapshots of affected defaults domains, so recommend using it soon after a bad run rather than after making many unrelated preference changes.

## Current Profile

Read `references/current-preferences.md` when the user asks what will be changed, wants to extend the setup, or reports a mismatch after running the script.
