#!/usr/bin/env bash
set -euo pipefail

log() {
    echo "[*] $1"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$EUID" -eq 0 ]; then
    log "Don't run as root"
    exit 1
fi

if ! command -v pacman &>/dev/null; then
    log "This script is for Arch-based systems"
    exit 1
fi

install_yay() {
    if ! command -v yay &>/dev/null; then
        log "Installing yay..."
        sudo pacman -S --needed --noconfirm git base-devel
        rm -rf /tmp/yay
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        (
            cd /tmp/yay
            makepkg -si --noconfirm
        )
        rm -rf /tmp/yay
    else
        log "yay already installed"
    fi
}

install_official() {
    log "Installing official packages..."
    official=(
        hyprland
        waybar
        rofi
        swaync
        swww
        xdg-desktop-portal-hyprland
        qt5-wayland
        qt6-wayland
        polkit-gnome
        kitty
        zsh
        zsh-completions
        fzf
        neovim
        thunar
        network-manager-applet
        blueman
        dbus
        playerctl
        grim
        slurp
        eza
        bat
        zoxide
        uv
        python
        git
        ttf-jetbrains-mono-nerd
        noto-fonts
        noto-fonts-emoji
    )
    sudo pacman -S --needed --noconfirm "${official[@]}"
}

install_aur() {
    log "Installing AUR packages..."
    aur=(
        waybar-mpris
        eww
        rofi-bluetooth
        nitch
        nvm
        spicetify-cli
    )
    if ! command -v yay &>/dev/null; then
        log "Error: yay not installed"
        exit 1
    fi
    yay -S --needed --noconfirm "${aur[@]}"
}

install_zinit() {
    if [ ! -f "$HOME/.config/zsh/zinit/zinit.zsh" ]; then
        log "Installing zinit..."
        bash -c "$(curl --fail --show-error --silent --location \
            https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)" \
            -- --no-pager 2>/dev/null || true
    else
        log "zinit already installed"
    fi
}

setup_zsh() {
    log "Setting up Zsh..."
    mkdir -p "$HOME/.local/share/zsh"
    touch "$HOME/.local/share/zsh/history"
    mkdir -p "$HOME/.cache/zsh"
    if [ "$SHELL" != "$(command -v zsh)" ]; then
        log "Changing default shell to zsh..."
        chsh -s "$(command -v zsh)"
    else
        log "zsh already default shell"
    fi
}

link_dotfiles() {
    CONFIG_DIR="$HOME/.config"
    WALLPAPER_DIR="$HOME/Pictures/"
    WALLPAPERS="$WALLPAPER_DIR/Wallpapers"
    ZSHENV="$HOME/.zshenv"
    mkdir -p "$CONFIG_DIR"
    mkdir -p "$WALLPAPER_DIR"
    log "Wallpaper Directory: $WALLPAPER_DIR"
    if [ ! -d "$WALLPAPERS" ]; then
        cp -r "$SCRIPT_DIR/Wallpapers" "$WALLPAPER_DIR"
    else
        mv "$WALLPAPERS" "$WALLPAPERS".bak
        cp -r "$SCRIPT_DIR/Wallpapers" "$WALLPAPER_DIR"
    fi
    if [ ! -f "$ZSHENV" ]; then
        cp "$SCRIPT_DIR/zshenv" "$ZSHENV"
    else
        mv "$ZSHENV" "$ZSHENV".bak
        cp "$SCRIPT_DIR/zshenv" "$ZSHENV"
    fi
    for d in waybar rofi kitty eww hypr nvim zsh; do
        SRC="$SCRIPT_DIR/config/$d"
        DST="$CONFIG_DIR/$d"
        if [ ! -d "$SRC" ]; then
            log "Warning: source $SRC not found, skipping"
            continue
        fi
        if [ -d "$DST" ]; then
            log "Backing up existing $DST → $DST.bak"
            mv "$DST" "$DST.bak"
        fi
        log "Copying $SRC → $DST"
        cp -r "$SRC" "$DST"
    done
    log "Dotfiles linked successfully."
}

main() {
    install_yay
    install_official
    install_aur
    install_zinit
    setup_zsh
    link_dotfiles
    log "Done!"
    while :; do
        printf "Reboot the system? (y/n): "
        read answer
        case "$answer" in
        y | Y)
            printf "Rebooting...\n"
            sudo reboot
            break
            ;;
        n | N)
            printf "Cancelled.\n"
            break
            ;;
        *)
            printf "Invalid input.\n"
            ;;
        esac
    done
}

main
