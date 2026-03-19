#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/style/style-panel.rasi"

options="Shutdown
Reboot
Lock
Cancel"

confirm() {
  echo -e "Yes\nNo" | rofi -dmenu -p "Are you sure?" -theme "$ROFI_THEME"
}

choice=$(echo -e "$options" | rofi -dmenu -p "Powermenu" -i -I -theme "$ROFI_THEME")

case "$choice" in
Shutdown)
  [[ "$(confirm)" == "Yes" ]] && systemctl poweroff
  ;;
Reboot)
  [[ "$(confirm)" == "Yes" ]] && systemctl reboot
  ;;
Lock)
  if command -v hyprlock >/dev/null; then
    hyprlock
  elif command -v betterlockscreen >/dev/null; then
    betterlockscreen -l
  else
    i3lock
  fi
  ;;
Cancel)
  exit
  ;;
esac
notify-send "Powermenu" "$choice"
