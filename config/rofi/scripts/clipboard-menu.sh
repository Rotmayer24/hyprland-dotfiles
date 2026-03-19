#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/style/style-panel.rasi"

options="Clipboard Text
Clipboard Image
Cancel"

choice=$(echo -e "$options" | rofi -dmenu -p "Clipboard" -i -I -theme "$ROFI_THEME")

case "$choice" in
Clipboard\ Text)
  bash $HOME/.config/rofi/scripts/clipboard/clipboard-text.sh
  ;;

Clipboard\ Image)
  bash $HOME/.config/rofi/scripts/clipboard/clipboard-image.sh
  ;;

Cancel)
  exit
  ;;
esac
