#!/usr/bin/env bash
set -euo pipefail

find "$HOME/Pictures/Wallpapers" \
    -type f \
    \( \
        -iname "*.jpg" \
        -o -iname "*.jpeg" \
        -o -iname "*.png" \
        -o -iname "*.webp" \
        -o -iname "*.gif" \
    \) \
| sort
