#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/style/style-panel.rasi"

options="Quickshell
Waybar
Hyprpanel
Ewww
Killall"

choice=$(echo -e "$options" | rofi -dmenu -p "Panels" -i -I -theme "$ROFI_THEME")

[ -z "$choice" ] && exit 0

case "$choice" in
Quickshell)
    qs ipc call luci toggleBar
    ;;
Waybar)
    ~/.config/rofi/scripts/waybar-switch.sh &
    ;;
Hyprpanel)
    killall -9 waybar 2>/dev/null
    eww kill
    killall -9 gjs 2>/dev/null
    hyprpanel &
    ;;
Ewww)
    killall -9 waybar 2>/dev/null
    eww kill
    killall -9 gjs 2>/dev/null
    bash -c 'eww open bar_widget && eww update get_vol="$(pamixer --get-volume)" && ~/.config/eww/scripts/getvol.sh'
    bash -c '~/.config/eww/scripts/workspace.sh'
    ewww daemon &
    ;;
Killall)
    killall -9 waybar 2>/dev/null
    eww kill
    killall -9 gjs 2>/dev/null
    qs ipc call luci toggleBar
    ;;
esac

notify-send "Panel switched to $choice"
