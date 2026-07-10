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
        hyprlock
        hypridle
        waybar
        rofi
        swaync
        swww
        xdg-desktop-portal-hyprland
        qt5-wayland
        qt6-wayland
        polkit-gnome
        kitty
        firefox
        zsh
        zsh-completions
        fzf
        neovim
        thunar
        network-manager-applet
        blueman
        dbus
        playerctl
        pipewire
        pipewire-pulse
        wireplumber
        brightnessctl
        grim
        slurp
        wl-clipboard
        cliphist
        hyprpicker
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
        waybar-mpris-git
        eww
        rofi-bluetooth
        nitch
        nvm
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
        if ! bash -c "$(curl --fail --show-error --silent --location \
            https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"; then
            log "Warning: zinit installation failed, check your internet connection"
        fi
    else
        log "zinit already installed"
    fi
}

setup_zsh() {
    log "Setting up Zsh..."
    mkdir -p "$HOME/.local/share/zsh"
    touch "$HOME/.local/share/zsh/history"
    mkdir -p "$HOME/.cache/zsh"

    current_shell="$(getent passwd "$USER" | cut -d: -f7)"
    zsh_path="$(command -v zsh)"

    if [ "$current_shell" != "$zsh_path" ]; then
        log "Changing default shell to zsh..."
        chsh -s "$zsh_path"
    else
        log "zsh already default shell"
    fi
}

link_dotfiles() {
    CONFIG_DIR="$HOME/.config"
    PICTURES_DIR="$HOME/Pictures"
    WALLPAPERS="$PICTURES_DIR/Wallpapers"
    ZSHENV="$HOME/.zshenv"

    mkdir -p "$CONFIG_DIR"
    mkdir -p "$PICTURES_DIR"

    log "Wallpaper directory: $WALLPAPERS"
    if [ -d "$WALLPAPERS" ]; then
        log "Backing up existing $WALLPAPERS → $WALLPAPERS.bak"
        mv "$WALLPAPERS" "$WALLPAPERS.bak"
    fi
    cp -r "$SCRIPT_DIR/Wallpapers" "$WALLPAPERS"

    if [ -f "$ZSHENV" ]; then
        log "Backing up existing $ZSHENV → $ZSHENV.bak"
        mv "$ZSHENV" "$ZSHENV.bak"
    fi
    cp "$SCRIPT_DIR/zshenv" "$ZSHENV"

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
        read -r answer
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
