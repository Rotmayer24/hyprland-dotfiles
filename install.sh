#!/usr/bin/env bash
set -euo pipefail

# ----------------- utils -----------------
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

# ----------------- install yay -----------------
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

# ----------------- official packages -----------------
install_official() {
  log "Installing official packages..."
  official=(
    hyprland
    kitty
    waybar
    rofi
    swaync
    swww
    playerctl
    network-manager-applet
    blueman
    dbus
    flameshot
  )
  sudo pacman -S --needed --noconfirm "${official[@]}"
}

# ----------------- AUR packages -----------------
install_aur() {
  log "Installing AUR packages..."
  aur=(
    waybar-mpris
    eww
  )
  if ! command -v yay &>/dev/null; then
    log "Error: yay not installed"
    exit 1
  fi
  yay -S --needed --noconfirm "${aur[@]}"
}

# ----------------- link dotfiles -----------------
link_dotfiles() {
  CONFIG_DIR="$HOME/.config"
  mkdir -p "$CONFIG_DIR"

  for d in waybar rofi kitty eww hypr; do
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

# ----------------- main -----------------
main() {
  install_yay
  install_official
  install_aur
  link_dotfiles

  log "Done! You can now start Hyprland or reboot your system."

}

main
