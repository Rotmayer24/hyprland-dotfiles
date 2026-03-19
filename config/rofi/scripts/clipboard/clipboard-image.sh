#!/bin/bash

ROFI_THEME="$HOME/.config/rofi/style/style-wallpaper.rasi"
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
        echo -e "\0icon\x1f$file"
      fi
    fi
  done | rofi -dmenu -i -show-icons -p "Clipboard Images" -theme "$ROFI_THEME"
)

[ -z "$menu" ] && exit

index=$(echo "$menu" | grep -o '[0-9]\+')

selected="${entries[$((index - 1))]}"

echo "$selected" | cliphist decode | wl-copy

notify-send "Copied image to clipboard"
