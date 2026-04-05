# Hyprland Configuration

A clean and functional **Hyprland** setup focused on productivity, minimalism, and a smooth workflow.
This configuration is designed for Wayland environments and includes a curated set of tools, themes, and scripts.

---

## Rice Gif

![Rice](rice.gif)

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

* **Eww**
  https://github.com/Mon4sm/monasm-dots

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
| SUPER + B               | Power Menu

---
## Notes

* You can add wallpapers in `~/Pictures/Wallpapers`.
* You can add your Waybar configurations in `~/.config/waybar/themes` using `.jsonc` and `.css` files.
* Hyprland version = 0.54.2

---

## 🚀 Installation

Clone the repository:

```bash
git clone https://github.com/yourusername/your-hyprland-config.git
cd hyprland-dotfiles
bash ./install.sh

```
---

## 🧠 Credits

* adi1090x (Rofi themes)
* pinkSakoora (Hyprlock config)
* michaelScopic(Wallpapers)
* Mon4sm (Eww config)

---

## 📄 License

MIT License

---
