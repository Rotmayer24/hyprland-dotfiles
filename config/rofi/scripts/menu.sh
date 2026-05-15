#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/style/style-panel.rasi"


options="Panels
Power
Wallpaper
Clipboard
Screenshot"

choice=$(echo -e "$options" | rofi -dmenu -p "Menu" -i -I -theme "$ROFI_THEME")

case "$choice" in
Panels)
    ~/.config/rofi/scripts/switch-panel.sh &
    ;;

Power)
    ~/.config/rofi/scripts/powermenu.sh &
    ;;

Wallpaper)
    ~/.config/rofi/scripts/wallpaper.sh &
    ;;

Clipboard)
    ~/.config/rofi/scripts/clipboard-menu.sh &
    ;;

Screenshot)
    ~/.config/rofi/scripts/screenshot.sh &
    ;;
esac

