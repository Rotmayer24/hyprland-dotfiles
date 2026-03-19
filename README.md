# Hyprland Configuration

A clean and functional **Hyprland** setup focused on productivity, minimalism, and a smooth workflow.
This configuration is designed for Wayland environments and includes a curated set of tools, themes, and scripts.

---

## ✨ Features

* Minimal and fast **Hyprland** configuration
* Wallpaper picker with preview (Rofi-based)
* Smooth wallpaper transitions using `swww`
* Clean and modern lock screen

---

## 🧩 Components

| Component    | Program             |
| ------------ | --------            |
| Terminal     | kitty               |
| Browser      | firefox             |
| File Manager | Dolphin             |
| Lock Screen  | hyprlock            |
| Launcher     | rofi                |
| Wallpaper    | swww                |
| Panel        | waybar/hyprpanel/eww|

---

## 🔗 External Resources

* **Hyprlock config**
  https://github.com/pinkSakoora/sakoora.hyprlock

* **Rofi themes**
  https://github.com/adi1090x/rofi

* **Wallpapers**
  https://github.com/michaelScopic/Wallpapers

---

## 🖼 Wallpaper System

This setup uses:

* `swww` for dynamic wallpaper rendering
* Custom script with:

  * Folder navigation
  * Image previews inside Rofi
  * Quick wallpaper switching

---

## ⌨ Keybindings (Highlights)

| Keybind             | Action                         |
| ------------------- | ------------------------------ |
| SUPER + H / L           | Switch workspace (prev / next) |
| SUPER + SHIFT + H/L     | Move window between workspaces |
| SUPER + 1-9,0           | Switch workspace               |
| SUPER + SHIFT + [1-9,0] | Move window between workspaces |
| SUPER + Q               | Open terminal (kitty)          |
| SUPER + R               | Open Rofi                      |
| SUPER + W               | Wallpaper Menu                 |
| SUPER + V               | Clipboard                      |
| SUPER + N               | Switch Panel                   |
| SUPER + M               | Hyprlock                       |
| SUPER + T               | Toggle Floating                |
| SUPER + F               | Fullscreen                     |
| SUPER + SHIFT + S       | Part Screen                    |
| SUPER + SHIFT + P       | Screenshot Menu                |
| SUPER +  P              | Hyprpicker                     |
| SUPER + J               | Toggle Split                   |
| SUPER + K               | Swap Split                     |
| SUPER + X               | Browser (Firefox)              |

---

## 🚀 Installation

Clone the repository:

```bash
git clone https://github.com/yourusername/your-hyprland-config.git
cd your-hyprland-config
bash ./install.sh

```
---

## 🧠 Credits

* adi1090x (Rofi themes)
* pinkSakoora (Hyprlock config)
* Mon4sm (Eww config)

---

## 📄 License

MIT License (or your choice)

---
