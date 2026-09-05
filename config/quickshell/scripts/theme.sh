#!/usr/bin/env bash
set -euo pipefail

THEME="$1"

if [[ -z "$THEME" ]]; then
    echo "Usage: theme-switch.sh <theme>"
    exit 1
fi

THEMES_DIR="$HOME/.config/quickshell/styles/themes"
THEME_DIR="$THEMES_DIR/$THEME"

if [[ ! -d "$THEME_DIR" ]]; then
    echo "Theme '$THEME' not found."
    exit 1
fi

link_if_exists() {
    local source="$1"
    local target="$2"

    if [[ -f "$source" ]]; then
        mkdir -p "$(dirname "$target")"
        ln -sf "$source" "$target"
        echo "✓ $(basename "$target")"
    else
        echo "✗ Missing: $source"
    fi
}

# -------------------------
# Wallpaper (random from theme)
# -------------------------

WALLPAPERS_JSON="$HOME/.config/quickshell/assets/wallpapers.json"
WP_DIR="$HOME/Pictures/Wallpapers"

if [[ -f "$WALLPAPERS_JSON" ]]; then
    THEME_FILES=$(jq -r --arg t "$THEME" '.[] | select(.theme == $t) | .files[]' "$WALLPAPERS_JSON" 2>/dev/null)

    if [[ -n "$THEME_FILES" ]]; then
        WP_PATHS=()
        while IFS= read -r fname; do
            MATCH=$(find "$WP_DIR" -type f -iname "$fname" 2>/dev/null | head -1)
            if [[ -n "$MATCH" ]]; then
                WP_PATHS+=("$MATCH")
            fi
        done <<< "$THEME_FILES"

        if [[ ${#WP_PATHS[@]} -gt 0 ]]; then
            RANDOM_WP="${WP_PATHS[$((RANDOM % ${#WP_PATHS[@]}))]}"
            awww img "$RANDOM_WP" \
                --transition-type grow \
                --transition-duration 2 \
                --transition-fps 60 || true
            echo "✓ wallpaper: $(basename "$RANDOM_WP")"
        else
            echo "○ wallpaper: no matching files found for $THEME"
        fi
    else
        echo "○ wallpaper: no entries for $THEME in wallpapers.json"
    fi
else
    echo "○ wallpaper: wallpapers.json not found"
fi

# -------------------------
# Kitty
# -------------------------

if [[ -f "$THEME_DIR/kitty.conf" ]]; then
    KITTY_OUT=$(sed -n '/^# END_KITTY_THEME$/,$ { /^# END_KITTY_THEME$/d; p; }' "$THEME_DIR/kitty.conf" \
        | sed '/^$/d')
    if [[ -n "$KITTY_OUT" ]]; then
        echo "$KITTY_OUT" > "$HOME/.config/kitty/current-theme.conf"
        echo "✓ kitty current-theme.conf"
    else
        echo "○ kitty: no theme content after marker in kitty.conf"
    fi
fi

# -------------------------
# Hyprland
# -------------------------

link_if_exists \
    "$THEME_DIR/HyprTheme.lua" \
    "$HOME/.config/hypr/current-theme/theme.lua"

# -------------------------
# Neovim
# -------------------------

case "$THEME" in
    catppuccin)      NVIM_THEME="catppuccin" ;;
    catppuccinlatte) NVIM_THEME="catppuccin" ;;
    gruvbox)         NVIM_THEME="gruvbox" ;;
    gruvboxlight)    NVIM_THEME="gruvbox" ;;
    tokyonight)      NVIM_THEME="tokyonight" ;;
    dracula)         NVIM_THEME="dracula" ;;
    rosepine)        NVIM_THEME="rose-pine" ;;
    nord)            NVIM_THEME="nord" ;;
    everforest)      NVIM_THEME="everforest" ;;
    solarized)       NVIM_THEME="solarized" ;;
    monochrome)      NVIM_THEME="monochrome" ;;
    githublight)     NVIM_THEME="github_light" ;;
    *)               NVIM_THEME="tokyonight" ;;
esac

NVIM_SOCK=$(find "/run/user/$(id -u)/" -name "nvim.*.0" -type s 2>/dev/null | head -1 || true)
if [[ -n "$NVIM_SOCK" ]] && [[ -S "$NVIM_SOCK" ]]; then
    nvim --remote-send "<cmd>lua SetTheme('$NVIM_THEME')<CR>" --server "$NVIM_SOCK" 2>/dev/null && \
        echo "✓ neovim: $NVIM_THEME" || \
        echo "✗ neovim: server not responding"
else
    echo "○ neovim: will apply on next start ($NVIM_THEME)"
fi

echo

echo "$THEME" > "$HOME/.config/quickshell/.current_theme"

# -------------------------
# Zsh / Powerlevel10k
# -------------------------

ZSH_THEME_FILE="$HOME/.config/zsh/themes/${THEME}.zsh"
if [[ -f "$ZSH_THEME_FILE" ]]; then
    cp "$ZSH_THEME_FILE" "$HOME/.config/quickshell/.p10k-theme.zsh"
    echo "✓ p10k theme colors"
else
    echo "○ p10k: no color file for $THEME"
fi

# Signal all zsh instances to reload p10k
pkill -u "$USER" -USR1 zsh 2>/dev/null && \
    echo "✓ zsh: signaled to reload" || \
    echo "○ zsh: no running shells to signal"

