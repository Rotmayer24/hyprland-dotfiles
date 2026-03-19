#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/style/style-main.rasi"
TMP_DIR="/tmp/cliphist-previews"

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

i=0
mapfile -t entries < <(cliphist list)

menu=$(
  for entry in "${entries[@]}"; do
    ((i++))

    if [[ "$entry" == *"binary data"* ]]; then
      file="$TMP_DIR/$i.png"

      echo "$entry" | cliphist decode >"$file" 2>/dev/null

      if file "$file" | grep -q image; then
        echo -e "[Image $i]\0icon\x1f$file"
      else
        echo "[Binary $i]"
      fi
    else
      echo "$entry"
    fi
  done | rofi -dmenu -i -show-icons -p "Clipboard" -theme "$ROFI_THEME" -theme-str 'window { width: 1000px; } listview { columns: 1; lines: 10; }'
)

[ -z "$menu" ] && exit

index=$(echo "$menu" | grep -o '[0-9]\+')

selected="${entries[$((index - 1))]}"

echo "$selected" | cliphist decode | wl-copy

notify-send "Copied"
