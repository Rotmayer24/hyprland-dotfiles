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

            printf '%s\n' "$entry" | cliphist decode >"$file" 2>/dev/null

            if file "$file" | grep -q image; then
                printf '[Image %d]\0icon\x1f%s\n' "$i" "$file"
            else
                printf '[Binary %d]\n' "$i"
            fi
        else
            printf '%s\n' "$entry"
        fi
    done |
        rofi -dmenu -i -show-icons \
            -p "Clipboard" \
            -format i \
            -theme "$ROFI_THEME" \
            -theme-str 'window { width: 1000px; } listview { columns: 1; lines: 10; }'
)

[ -z "$menu" ] && exit 0

index=$((menu + 1))

selected="${entries[$((index - 1))]}"

printf '%s\n' "$selected" | cliphist decode | wl-copy

notify-send "Copied" "Clipboard copied"
