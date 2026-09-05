# Hyprland Configuration

A clean and functional **Hyprland** setup focused on productivity, minimalism, and a smooth workflow.

This configuration is designed for Wayland environments and includes a curated set of tools, themes, and scripts.

*(Minimal version of Hyprland 0.55.0)*

---

## Rice Gif

![Rice](rice.gif)

---

## Features

* Minimal and fast **Hyprland** configuration
* Island-style quickshell bar with dynamic views
* Wallpaper picker with theme-based filtering
* Smooth wallpaper transitions using `awww`
* Clean and modern lock screen (hyprlock)
* Theme switcher with live preview (kitty, nvim, hyprland, waybar)

---

## Components

| Component    | Program                |
| ------------ | ---------------------- |
| Bar          | quickshell (island)    |
| Terminal     | kitty                  |
| Browser      | firefox                |
| File Manager | dolphin                |
| Lock Screen  | hyprlock               |
| Launcher     | rofi                   |
| Wallpaper    | awww                   |
| Panel        |waybar / hyprpanel / eww|
| Clipboard    |cliphist + wl-clipboard |
| Music        | playerctl              |
| Screenshots  | grim + slurp           |
| Neovim       | neovim + lazy plugins  |

---

## Keybindings

| Keybind                 | Action                          |
| ------------------------ | -------------------------------- |
| SUPER + [1-9, 0]         | Switch workspace                 |
| SUPER + SHIFT + [1-9, 0] | Move window between workspaces   |
| SUPER + Q                | Open terminal (kitty)            |
| SUPER + R                | Open App Launcher                |
| SUPER + W                | Wallpaper Selector               |
| SUPER + V                | Clipboard Manager                |
| SUPER + B                | Power Menu                       |
| SUPER + SHIFT + T        | Theme Selector                   |
| SUPER + M                | Toggle Bar                       |
| SUPER + SHIFT + L        | Lock Screen                      |
| SUPER + T                | Toggle floating                  |
| SUPER + F                | Fullscreen                       |
| SUPER + SHIFT + S        | Partial screenshot (region)      |
| SUPER + SHIFT + P        | Screenshot menu                  |
| SUPER + P                | Hyprpicker                       |
| SUPER + J                | Toggle split                     |
| SUPER + K                | Swap split                       |
| SUPER + X                | Browser (Firefox)                |
| SUPER + S                | Toggle special workspace         |
| SUPER + Z                | Move window to special workspace |
| XF86AudioRaiseVolume     | Volume up                        |
| XF86AudioLowerVolume     | Volume down                      |
| XF86AudioMute            | Toggle mute                      |
| XF86MonBrightnessUp      | Brightness up                    |
| XF86MonBrightnessDown    | Brightness down                  |

---

## Notes

* You can add wallpapers to `~/Pictures/Wallpapers` (supports subfolders by theme).
* Theme wallpapers are mapped in `~/.config/quickshell/assets/wallpapers.json`.
* You can add your Waybar configurations to `~/.config/waybar/themes` using `.jsonc` and `.css` files.

---

## Installation

Clone the repository:

```bash
git clone https://github.com/Rotmayer24/hyprland-dotfiles.git
cd hyprland-dotfiles
bash ./install.sh
```

---

## Credits

* **adi1090x** — Rofi themes
* **pinkSakoora** — Hyprlock config
* **michaelScopic** — Wallpapers
* **Mon4sm** — Eww config
* **ElhamSadiqi** — Luci
* **Shanu-Kumawat** — quickshell overview

---

## License

MIT License
