#!/usr/bin/env bash

THEME_DIR="$HOME/.config/waybar/themes"
CONFIG="$HOME/.config/waybar/config.jsonc"
CONFIG_STYLE="$HOME/.config/waybar/style.css"
ROFI_THEME="$HOME/.config/rofi/style/style-panel.rasi"
THEME_STYLE_DIR="$HOME/.config/waybar/styles"

THEMES=$(ls "$THEME_DIR"/*.jsonc | xargs -n1 basename | sed 's/\.jsonc$//')

OPTIONS="$THEMES"$'\n'"Back"

THEME=$(echo -e "$OPTIONS" | rofi -dmenu -i -I -p "Select Waybar theme:" -theme "$ROFI_THEME")

if [[ "$THEME" == "Back" ]]; then
  bash $HOME/.config/rofi/scripts/switch-panel.sh
fi

if [[ -n "$THEME" && -f "$THEME_DIR/$THEME.jsonc" ]]; then
  cp "$THEME_STYLE_DIR/$THEME.css" "$CONFIG_STYLE"
  cp "$THEME_DIR/$THEME.jsonc" "$CONFIG"
  killall -9 waybar 2>/dev/null
  eww kill
  killall -9 gjs 2>/dev/null
  waybar &
  notify-send "Waybar theme switched to $THEME"
fi
