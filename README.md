# Hyprland Configuration

A clean and functional **Hyprland** setup focused on productivity, minimalism, and a smooth workflow.

This configuration is designed for Wayland environments and includes a curated set of tools, themes, and scripts.

*(Minimal version of Hyprland 0.55.0)*

---

## Rice Gif

![Rice](rice.gif)

---

## ✨ Features

* Minimal and fast **Hyprland** configuration
* Wallpaper picker with preview (Rofi-based)
* Smooth wallpaper transitions using `swww`
* Clean and modern lock screen

---

## 🧩 Components

| Component    | Program               |
| ------------ | --------------------- |
| Terminal     | kitty                 |
| Browser      | firefox               |
| File Manager | Dolphin               |
| Lock Screen  | hyprlock              |
| Launcher     | rofi                  |
| Wallpaper    | swww                  |
| Panel        | waybar / hyprpanel / eww |

---

## 🔗 External Resources

* **Hyprlock config** — https://github.com/pinkSakoora/sakoora.hyprlock
* **Rofi themes** — https://github.com/adi1090x/rofi
* **Wallpapers** — https://github.com/michaelScopic/Wallpapers
* **Eww** — https://github.com/Mon4sm/monasm-dots

---

## ⌨ Keybindings (Highlights)

| Keybind                 | Action                          |
| ------------------------ | -------------------------------- |
| SUPER + [1-9, 0]          | Switch workspace                 |
| SUPER + SHIFT + [1-9, 0]  | Move window between workspaces   |
| SUPER + Q                | Open terminal (kitty)            |
| SUPER + R                | Open Rofi                        |
| SUPER + W                | Wallpaper menu                   |
| SUPER + V                | Clipboard                        |
| SUPER + N                | Switch Waybar                    |
| SUPER + O                | Switch panel                     |
| SUPER + M                | Hyprlock                         |
| SUPER + T                | Toggle floating                  |
| SUPER + F                | Fullscreen                       |
| SUPER + SHIFT + S         | Partial screenshot (region)      |
| SUPER + SHIFT + P         | Screenshot menu                  |
| SUPER + P                | Hyprpicker                       |
| SUPER + J                | Toggle split                     |
| SUPER + K                | Swap split                       |
| SUPER + X                | Browser (Firefox)                |
| SUPER + B                | Power menu                       |
| SUPER + I                | Menu (power, screenshot, etc.)   |
| SUPER + S                | Toggle special workspace         |
| SUPER + Z                | Move window to special workspace |

---

## 📝 Notes

* You can add wallpapers to `~/Pictures/Wallpapers`.
* You can add your Waybar configurations to `~/.config/waybar/themes` using `.jsonc` and `.css` files.

---

## 🚀 Installation

Clone the repository:

```bash
git clone https://github.com/Rotmayer24/hyprland-dotfiles.git
cd hyprland-dotfiles
bash ./install.sh
```

---

## 🧠 Credits

* **adi1090x** — Rofi themes
* **pinkSakoora** — Hyprlock config
* **michaelScopic** — Wallpapers
* **Mon4sm** — Eww config

---

## 📄 License

MIT License
