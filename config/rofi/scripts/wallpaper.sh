#!/bin/bash

dir="$HOME/Pictures/Wallpapers"
current="$dir"
ROFI_THEME="$HOME/.config/rofi/style/style-wallpaper.rasi"

set_wall() {
  swww img "$1" --transition-type any --transition-duration 1
}

while true; do
  choice=$(
    {
      find "$current" -maxdepth 1 -mindepth 1 \
        \( -type d \
        -o -iname "*.jpg" \
        -o -iname "*.png" \
        -o -iname "*.jpeg" \
        -o -iname "*.gif" \
        -o -iname "*.webp" \) | while read -r file; do

        name=$(basename "$file")

        if [[ -d "$file" ]]; then
          echo -e "$name\0icon\x1ffolder"
        else
          echo -e "$name\0icon\x1f$file"
        fi

      done | sort

      echo -e "Back\0icon\x1fgo-previous"
    } | rofi -dmenu -i -show-icons -p "$current" -theme "$ROFI_THEME"
  )

  [[ -z "$choice" ]] && exit

  # Back
  if [[ "$choice" == "Back" ]]; then
    [[ "$current" == "$dir" ]] && continue
    current=$(dirname "$current")
    continue
  fi

  full="$current/$choice"

  if [[ -d "$full" ]]; then
    current="$full"
    continue
  fi

  action=$(
    printf "set\0icon\x1fimage\ncancel\0icon\x1fwindow-close" |
      rofi -dmenu -show-icons -p "$choice" -theme "$ROFI_THEME"
  )

  if [[ "$action" == "set" ]]; then
    set_wall "$full"
    notify-send "$choice"
  fi
done
