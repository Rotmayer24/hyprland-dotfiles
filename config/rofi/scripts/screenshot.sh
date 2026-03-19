#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/style/style-panel.rasi"

options="Fullscreen
Part screen
Cancel"

choice=$(echo -e "$options" | rofi -dmenu -p "Screenshot Menu" -i -I -theme "$ROFI_THEME")

case "$choice" in
Part\ screen)
  flameshot gui -c
  ;;

Fullscreen)
  flameshot full -c
  ;;

Cancel)
  exit
  ;;
esac

notify-send "Screenshot" "Take $choice"
