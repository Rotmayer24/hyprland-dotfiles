#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/style/style-main.rasi"

mapfile -t entries < <(cliphist list)

menu=$(
  for entry in "${entries[@]}"; do
    if [[ "$entry" != *"binary data"* ]]; then
      echo "$entry"
    fi
  done | rofi -dmenu -i -p "Clipboard" -theme "$ROFI_THEME" -theme-str 'window { width: 1000px; } listview { columns: 1; lines: 10; }'
)

[ -z "$menu" ] && exit

selected="$menu"

echo "$selected" | wl-copy

notify-send "Copied text to clipboard"
