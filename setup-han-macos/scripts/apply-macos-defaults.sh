#!/usr/bin/env bash
set -euo pipefail

echo "Applying Han macOS defaults..."

create_backup() {
  local backup_root="${HAN_MACOS_BACKUP_ROOT:-${HOME}/.han-macos-defaults-backups}"
  local backup_dir="${backup_root}/$(date +%Y%m%d-%H%M%S)-$$"

  mkdir -p "$backup_dir"

  export_domain() {
    local domain="$1"
    local file="$2"

    if defaults export "$domain" "${backup_dir}/${file}" 2>/dev/null; then
      return
    fi

    printf '%s\n' "$domain" >"${backup_dir}/${file}.missing"
  }

  defaults export -g "${backup_dir}/global.plist"
  defaults -currentHost export -g "${backup_dir}/currenthost-global.plist"
  export_domain com.apple.AppleMultitouchTrackpad com.apple.AppleMultitouchTrackpad.plist
  export_domain com.apple.driver.AppleBluetoothMultitouch.trackpad com.apple.driver.AppleBluetoothMultitouch.trackpad.plist
  export_domain com.apple.AppleMultitouchMouse com.apple.AppleMultitouchMouse.plist
  export_domain com.apple.driver.AppleBluetoothMultitouch.mouse com.apple.driver.AppleBluetoothMultitouch.mouse.plist
  export_domain com.apple.dock com.apple.dock.plist
  export_domain com.apple.finder com.apple.finder.plist
  hidutil property --get UserKeyMapping >"${backup_dir}/hidutil-UserKeyMapping.txt" 2>/dev/null || true

  cat >"${backup_dir}/restore.sh" <<'RESTORE'
#!/usr/bin/env bash
set -euo pipefail

backup_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

restore_domain() {
  local domain="$1"
  local file="$2"

  if [[ -f "${backup_dir}/${file}" ]]; then
    defaults import "$domain" "${backup_dir}/${file}"
  elif [[ -f "${backup_dir}/${file}.missing" ]]; then
    defaults delete "$domain" 2>/dev/null || true
  fi
}

defaults import -g "${backup_dir}/global.plist"
defaults -currentHost import -g "${backup_dir}/currenthost-global.plist"
restore_domain com.apple.AppleMultitouchTrackpad com.apple.AppleMultitouchTrackpad.plist
restore_domain com.apple.driver.AppleBluetoothMultitouch.trackpad com.apple.driver.AppleBluetoothMultitouch.trackpad.plist
restore_domain com.apple.AppleMultitouchMouse com.apple.AppleMultitouchMouse.plist
restore_domain com.apple.driver.AppleBluetoothMultitouch.mouse com.apple.driver.AppleBluetoothMultitouch.mouse.plist
restore_domain com.apple.dock com.apple.dock.plist
restore_domain com.apple.finder com.apple.finder.plist

killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true

echo "Restored defaults from ${backup_dir}."
echo "Log out or reboot if keyboard or trackpad changes do not fully revert in the current session."
RESTORE

  chmod +x "${backup_dir}/restore.sh"

  printf '%s\n' "Backup created at ${backup_dir}"
  printf '%s\n' "Restore with: ${backup_dir}/restore.sh"
}

create_backup

###############################################################################
# Keyboard
###############################################################################

# Fast key repeat. Current machine: InitialKeyRepeat=15, KeyRepeat=2.
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# Caps Lock -> Right Control.
# Source 0x700000039 = Caps Lock, destination 0x7000000E4 = Right Control.
defaults -currentHost write -g com.apple.keyboard.modifiermapping.0-0-0 -array \
  '{"HIDKeyboardModifierMappingSrc" = 30064771129; "HIDKeyboardModifierMappingDst" = 30064771300;}'

# Apply the same mapping immediately for the current login session.
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E4}]}' || true

###############################################################################
# Trackpad
###############################################################################

defaults write -g com.apple.trackpad.forceClick -bool false
defaults write -g com.apple.trackpad.scaling -float 1

for domain in com.apple.AppleMultitouchTrackpad com.apple.driver.AppleBluetoothMultitouch.trackpad; do
  defaults write "$domain" Clicking -bool true
  defaults write "$domain" DragLock -bool false
  defaults write "$domain" Dragging -bool false
  defaults write "$domain" TrackpadRightClick -bool true
  defaults write "$domain" TrackpadThreeFingerDrag -bool true
  defaults write "$domain" TrackpadThreeFingerTapGesture -int 2
  defaults write "$domain" TrackpadThreeFingerHorizSwipeGesture -int 0
  defaults write "$domain" TrackpadThreeFingerVertSwipeGesture -int 0
  defaults write "$domain" TrackpadTwoFingerDoubleTapGesture -int 1
  defaults write "$domain" TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3
  defaults write "$domain" TrackpadFourFingerHorizSwipeGesture -int 2
  defaults write "$domain" TrackpadFourFingerVertSwipeGesture -int 2
  defaults write "$domain" TrackpadFourFingerPinchGesture -int 2
  defaults write "$domain" TrackpadFiveFingerPinchGesture -int 2
  defaults write "$domain" TrackpadHorizScroll -bool true
  defaults write "$domain" TrackpadScroll -bool true
  defaults write "$domain" TrackpadMomentumScroll -bool true
  defaults write "$domain" TrackpadPinch -bool true
  defaults write "$domain" TrackpadRotate -bool true
  defaults write "$domain" USBMouseStopsTrackpad -bool false
  defaults write "$domain" UserPreferences -bool true
done

defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool true
defaults -currentHost write -g com.apple.trackpad.threeFingerDragGesture -int 1
defaults -currentHost write -g com.apple.trackpad.threeFingerTapGesture -int 2
defaults -currentHost write -g com.apple.trackpad.scrollBehavior -int 2

###############################################################################
# Magic Mouse
###############################################################################

for domain in com.apple.AppleMultitouchMouse com.apple.driver.AppleBluetoothMultitouch.mouse; do
  defaults write "$domain" MouseButtonMode -string OneButton
  defaults write "$domain" MouseHorizontalScroll -bool true
  defaults write "$domain" MouseVerticalScroll -bool true
  defaults write "$domain" MouseMomentumScroll -bool true
  defaults write "$domain" MouseOneFingerDoubleTapGesture -int 0
  defaults write "$domain" MouseTwoFingerDoubleTapGesture -int 3
  defaults write "$domain" MouseTwoFingerHorizSwipeGesture -int 2
  defaults write "$domain" UserPreferences -bool true
done

###############################################################################
# Dock and Finder
###############################################################################

defaults write com.apple.dock autohide -bool true

defaults write com.apple.finder NewWindowTarget -string PfLo
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Downloads/"

killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true

echo "Done. Log out or reboot if keyboard or trackpad changes do not fully apply."
