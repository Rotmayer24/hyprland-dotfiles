# Hyprland Configuration

A clean and functional **Hyprland** setup focused on productivity, minimalism, and a smooth workflow.
This configuration is designed for Wayland environments and includes a curated set of tools, themes, and scripts.

---

## ✨ Features

* Minimal and fast **Hyprland** configuration
* Vim-like navigation (workspace & window control)
* Wallpaper picker with preview (Rofi-based)
* Smooth wallpaper transitions using `swww`
* Clean and modern lock screen
* Custom Rofi styling

---

## 🧩 Components

| Component    | Program  |
| ------------ | -------- |
| Terminal     | kitty    |
| Browser      | firefox  |
| File Manager | Dolphin  |
| Lock Screen  | hyprlock |
| Launcher     | rofi     |
| Wallpaper    | swww     |

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
| SUPER + H / L       | Switch workspace (prev / next) |
| SUPER + SHIFT + H/L | Move window between workspaces |
| SUPER + ENTER       | Open terminal (kitty)          |
| SUPER + D           | Open Rofi                      |

---

## 🚀 Installation

Clone the repository:

```bash
git clone https://github.com/yourusername/your-hyprland-config.git
cd your-hyprland-config
```

Copy configs:

```bash
cp -r .config/* ~/.config/
```

Install dependencies (example for Arch-based systems):

```bash
sudo pacman -S hyprland kitty dolphin firefox rofi swww jq
```

---

## ⚠️ Notes

* Make sure `swww-daemon` is running:

  ```bash
  swww-daemon &
  ```

* Rofi must support icons (`-show-icons`)

* Large wallpaper directories may slow down preview loading

---

## 📸 Screenshots

*(Add your screenshots here)*

---

## 📌 TODO

* [ ] Add animations tuning
* [ ] Improve Rofi UI (grid/gallery mode)
* [ ] Add more scripts

---

## 🧠 Credits

* Hyprland community
* adi1090x (Rofi themes)
* pinkSakoora (Hyprlock config)
* michaelScopic (Wallpapers)

---

## 📄 License

MIT License (or your choice)

---
